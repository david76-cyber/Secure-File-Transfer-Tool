# Secure-File-Transfer-Tool

# 🔐 Secure File Transfer Tool (PowerShell)

A lightweight PowerShell script that securely **encrypts or decrypts files using AES encryption**, with optional transfer logging. Great for basic file protection, testing encryption, or integrating secure file handling into scripts.

---

## 📌 Features

- ✅ AES-256 encryption using SHA-256-derived key
- 🔄 Supports both encryption and decryption modes
- 🗂️ Logs each transfer operation with timestamp
- 🔐 User-defined password-based protection
- 💻 Pure PowerShell — no external tools required

---

## 🚀 Usage

Run the script in PowerShell (as Administrator if needed):

```powershell
.\Secure_File_Transfer.ps1

You'll be prompted:
Choose mode [encrypt/decrypt]
Enter source file path
Enter destination file path
Enter password

📁 Output
Encrypted files are saved with the AES IV prepended.

A transfer log is automatically created:

Copy
Edit
📄 Transfer_Log_YYYY-MM-DD_HH-MM-SS.txt

🖥️ When the script runs, you’ll see:
powershell
Copy
Edit
Choose mode [encrypt/decrypt]: encrypt
Enter source file path: C:\Users\YourName\Desktop\secret.txt
Enter destination file path: C:\Users\YourName\Desktop\secret.enc
Enter password: 1234
✅ Make sure the file secret.txt exists in the location you typed.

📂 Example Decryption Prompt
After encryption, you can decrypt it with:

powershell
Copy
Edit
Choose mode [encrypt/decrypt]: decrypt
Enter source file path: C:\Users\YourName\Desktop\secret.enc
Enter destination file path: C:\Users\YourName\Desktop\decrypted.txt
Enter password: 1234

⚠️ Important Notes
Make sure to remember your encryption password — there's no recovery!

This script uses a symmetric encryption model (same password for encryption and decryption).

Requires Windows PowerShell 5.1+ (.NET required for AES crypto).

