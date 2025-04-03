# Windows Cache Cleaner
A lightweight, automated, and visually enhanced batch script to clean up temporary files and caches on **Windows systems**.
This version includes a **dynamic progress bar animation** and automatically closes the terminal after completion.

## 🌟 Features
- ✅ Supports Windows 10 / 11
- ✅ Automatically cleans:
  - System Temp files
  - User Temp files
  - Prefetch cache
  - Recycle Bin
- ✅ Dynamic progress bar animation
- ✅ Automatic exit after cleanup
- ✅ Fast, secure, and no external dependencies

## ⚙️ Usage
1. Download or copy the script
Save the following content as `clean_cache.bat`

Run as Administrator
Right-click the `.bat` file and select `Run as Administrator` to ensure full permission.

# 📄 Example Output
```bash
===============================
     Windows Cache Cleaner
===============================

Detecting Windows system...
Progress: [#####.............................................] 10%
Cleaning System Temp...
Progress: [#############.....................................] 30%
Cleaning User Temp...
Progress: [#########################.........................] 50%
Cleaning Prefetch...
Progress: [#####################################.............] 70%
Cleaning Recycle Bin...
Progress: [#############################################.....] 90%
Finalizing...
Progress: [##################################################] 100%

Cache cleanup completed!
```

>[!Note]
> This script will permanently delete temporary and cache files.
> Could you use it at your own risk?
> Please check and customize the script before execution.
> Administrator rights are required for full cleanup.

## 🧩 License
This project is released under the [MIT License](LICENSE).
