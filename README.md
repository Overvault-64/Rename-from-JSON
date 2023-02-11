# Rename from JSON - JSON-based bulk file renamer

Godot 4.0 source project included.

### How to use
1. Run the executable file.
2. Press 'Open Files Folder'. A file explorer windows will show up.
3. Put the files to be renamed in the 'to_rename' folder (Example: 5003.png, 5004.png).
4. Paste the content of your JSON file (Example: [{"id": 5003, "name": "dog"}, {"id": 5004, "name": "cat"}].
5. Enter the source name key (Example: id) and the end name key (Example: name) in the corresponding text areas.
6. Press 'Go'. All the files will be copied in the 'renamed' folder according to your JSON mapping (Example: 5003.png -> dog.png).

WARNING: Do NOT rename or delete the aforementioned folders. The app will not work as intended.

WARNING: Do NOT put folders into 'to_rename'. The app will just crash or something like that.

Tip: If you have a spreadsheet, you can just export it as a CSV and then convert CSV to JSON using [this](https://konbert.com/convert/csv/to/json).

Known issues:
- Sometimes the progress bar can be unprecise
