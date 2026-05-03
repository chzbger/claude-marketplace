const fs = require("fs");
const path = require("path");

const rulesPath = path.join(__dirname, "..", "rules", "conventions.md");
const content = fs.readFileSync(rulesPath, "utf8");

process.stdout.write(JSON.stringify({
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: content,
  },
}));
