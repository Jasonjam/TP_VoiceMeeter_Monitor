const net = require('node:net')
const { spawn } = require('node:child_process')
const path = require('node:path')
const readline = require('node:readline')

const PLUGIN_ID = 'com.jasonjam.voicemeeter.monitor'
const TP_PORT = 12136
const last = new Map()
let socket
let worker
let connected = false

function send(message) {
    if (!connected) return
    socket.write(JSON.stringify(message) + '\n')
}

function updateStates(values) {
    for (const [id, value] of Object.entries(values)) {
        if (last.get(id) === value) continue
        last.set(id, value)
        send({ type: 'stateUpdate', id, value })
    }
}

function startWorker() {
    if (worker) return
    worker = spawn('powershell.exe', [
        '-NoProfile', '-ExecutionPolicy', 'Bypass',
        '-File', path.join(__dirname, 'voicemeeter.ps1')
    ], { windowsHide: true })
    readline.createInterface({ input: worker.stdout }).on('line', line => {
        try {
            updateStates(JSON.parse(line))
        } catch (error) {
            console.error('Invalid Voicemeeter output:', line, error.message)
        }
    })
    worker.stderr.on('data', data => console.error(data.toString()))
    worker.on('exit', code => {
        worker = null
        console.error('Voicemeeter reader exited:', code)
        if (connected) setTimeout(startWorker, 3000)
    })
}

function connect() {
    socket = net.createConnection({ host: '127.0.0.1', port: TP_PORT })
    socket.on('connect', () => {
        connected = true
        last.clear()
        send({ type: 'pair', id: PLUGIN_ID })
        startWorker()
    })
    socket.on('data', () => {})
    socket.on('error', error => console.error('TP:', error.message))
    socket.on('close', () => {
        connected = false
        last.clear()
        if (worker) worker.kill()
        setTimeout(connect, 3000)
    })
}

connect()
