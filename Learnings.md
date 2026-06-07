---

This document outlines the engineering challenges faced and the debugging methodologies applied during the development of Task 1 and Task 2.

---

## 🪲 1. The Hardest Bug Fixed

### **Task 1 (LoginPage):**
* **The Issue:** Setting up asynchronous Firebase state changes caused a memory leak crash known as *"Unhandled Exception: setState() called after dispose()"* when a user clicked the submit button quickly multiple times or backed out of the page before the authentication request completed.

### **Task 2 (Calculator):**
* **The Issue:** The app would unexpectedly crash or display `Infinity` / `NaN` when a user attempted to divide a number by zero or click arithmetic operators consecutively (e.g., typing `5++3` or `9/-2`). 



---

## 🔍 2. How It Was Debugged & Solved

### **Debugging Process:**
1. **Console Analysis:** Used the **Flutter DevTools** log window to trace the exact line numbers throwing the exceptions during runtime.
2. **Breakpoints:** Placed debugging breakpoints right before string evaluation functions and authentication network calls to check variables like `inputExpression` or `userEmail`.

### **The Resolution:**

* **Task 1 Fix:** Added an `if (mounted)` verification check before invoking state modifications to guarantee that the UI context is active before processing backend authentication updates.

* **Task 2 Fix:** Implemented a try-catch validation blocks. If the string expression is structurally invalid, the UI smoothly displays an `"Error"` text state instead of breaking the execution thread.
