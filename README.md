# TouchPortal Plugin VMB

VMB stands for **Voicemeeter Banana**.

A read-only Touch Portal plugin for displaying Voicemeeter Gain values.

- Strip 0-7: `vm_strip_0_gain` through `vm_strip_7_gain`
- Bus 0-4: `vm_bus_0_gain` through `vm_bus_4_gain`
- Values are formatted to one decimal place (dB).
- Refresh interval: 500 ms. Unchanged values are not sent again.
- Requires Windows PowerShell and Voicemeeter Remote 64-bit DLL.

Touch Portal button text example:

```text
MIC
${value:vm_strip_0_gain} dB
```

Run locally: `node index.js`.
