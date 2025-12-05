# FlashRunner.nvim

A blazing-fast Neovim code runner plugin for executing code snippets directly from your editor.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## ✨ Features

- **Multi-language support**: C++, JavaScript, Python
- **Smart selection**: Runs the code block you heroically selected, or just bulldozes through the whole buffer if you forgot to select anything. Because who needs precision anyway?
- **Beautiful UI**: Output floating window with mesmerizing markdown rendering
- **Asynchronous execution**: Non-blocking code execution
- **Clean**: Zaps those pesky temp files into oblivion, so you can pretend you’re organized.

## 📺 Demo

<!-- TODO: Add demo GIF or video here -->

_Demo coming soon..._

### Screenshots

<!-- TODO: Add screenshots showing:
- Code selection and execution
- Floating window output
- Different language examples
-->

_Screenshots coming soon..._

## 📋 Requirements

### Core Dependencies

- **Neovim** >= 0.8.0
- **Node.js** (for JavaScript execution)
- **Python** (for Python execution)

### C++ Support (Optional but Recommended)

- **Cling** - C++ interpreter for REPL-like experience

```

> Installation methods may vary by platform. For the most accurate and up-to-date instructions, please refer to the official sources:
> https://root.cern/install/

```

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'jignesh119/FlashRunner.nvim',
  config = function()
    require('FlashRunner').setup()
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'jignesh119/FlashRunner.nvim',
  config = function()
    require('FlashRunner').setup()
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'jignesh119/FlashRunner.nvim'
```

Then add to your `init.lua`:

```lua
require('FlashRunner').setup()
```

## ⚙️ Configuration

### Default Configuration

```lua
require('FlashRunner').setup({
  keymap = "<leader>Fr", -- Default keymap for visual mode execution
})
```

<!-- ### Advanced Configuration -->
<!---->
<!-- ```lua -->
<!-- -- Set custom Cling runner path (optional) -->
<!-- vim.g.cling_runner_path = "/path/to/your/cling-runner.sh" -->
<!---->
<!-- -- Set execution timeout in milliseconds (optional) -->
<!-- vim.g.cling_runner_timeout_ms = 10000 -->
<!---->
<!-- require('FlashRunner').setup({ -->
<!--   keymap = "<leader>r", -- Custom keymap -->
<!-- }) -->
<!-- ``` -->

## 🚀 Usage

### Basic Usage

1. **Select code** in visual mode (`v`, `V`, or `Ctrl+v`)
2. **Press the keymap** (default: `<leader>Fr`)
3. **View results** in the floating window
4. **Press `q`** to close the output window

### Alternative: Command Usage

```vim
:FlashRunnerShow
```

### Language-Specific Examples

#### JavaScript

```javascript
console.log("Hello from FlashRunner!");
const sum = (a, b) => a + b;
console.log(sum(5, 3));
```

#### Python

```python
print("Hello from FlashRunner!")
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print(f"Fibonacci(10): {fibonacci(10)}")
```

#### C++ (with Cling)

```cpp
std::cout << "Hello from FlashRunner" << std::endl;
```

## 🛠️ Build and Development Instructions

### Setting Up Development Environment

1. **Clone the repository**:

   ```bash
   git clone https://github.com/jignesh119/FlashRunner.nvim.git
   cd FlashRunner.nvim
   ```

2. **Make the shell script executable**:

   ```bash
   chmod +x lua/FlashRunner/cling-runner.sh
   ```

3. **Install development dependencies**:

   ```bash
   # Install required interpreters
   sudo apt-get install nodejs python3 cling  # Ubuntu/Debian
   # OR
   brew install node python cling             # macOS
   ```

4. **Link plugin for development**:
   you can load the plugin from a local directory using your plugin manager.

```lua
return {
    dir = "/absolute/path/to/FlashRunner.nvim",
    config = function()
        require("FlashRunner").setup()
    end,
}
```

then sync to install/ register the plugin in neovim

```vim
:Lazy sync
```

then upon each update you may want to reload plugin

```vim
:Lazy reload FlashRunner
```

### Testing the Plugin

1. **Open Neovim** in the project directory

2. **Set up the plugin**:
   ```vim
   :lua require('FlashRunner').setup()
   ```
3. **Test with sample code** in supported languages with your own keymap(default is <leader>Fr)

### Shell Script Customization

The C++ execution uses a bash script (`lua/FlashRunner/cling-runner.sh`). To modify:

1. **Edit the script**:

   ```bash
   vim lua/FlashRunner/cling-runner.sh
   ```

2. **Key variables to customize**:

   - `TIMEOUT_SECONDS`: Execution timeout (default: 5)
   - Cling command and options
   - Output formatting

3. **Test the script directly**:
   ```bash
   echo 'std::cout << "test" << std::endl;' | ./lua/FlashRunner/cling-runner.sh
   ```

### Adding New Language Support

To add support for a new language:

1. **Add executor in `execution.lua`**:

   ```lua
   M.execute_newlang_code = M.create_system_executor("interpreter-command")
   ```

2. **Update language detection in `selection.lua`**:
   ```lua
   elseif language == "newlang" then
     executor = ExecutionEngine.execute_newlang_code
   ```

## 🔧 Troubleshooting

### Common Issues

1. **"No valid executor for this language"**

   - Ensure the file has the correct filetype (`:set filetype?`)
   - Verify language support in `selection.lua`
   - We currently support C++, JavaScript, Python

2. **C++ execution fails**

   - Install Cling interpreter
   - Check if `cling-runner.sh` is executable
   - Verify the script path in configuration

3. **JavaScript/Python execution fails**

   - Ensure Node.js/Python is installed and **in PATH**
   - Test with `node --version` or `python --version`

4. **Floating window doesn't appear**
   - Check for errors with `:messages`
   - Ensure Neovim version >= 0.8.0

## 🗺️ Roadmap

- [ ] **RPC Integration**: Handle interpretation in different programming languages
- [ ] **TypeScript Support**: Add ts-node executor
- [ ] **More Languages**: Rust, Go, Lua, PHP support
- [ ] **Configuration UI**: Interactive setup and language configuration
- [ ] **Execution History**: Save and replay previous executions
- [ ] **Custom Executors**: User-defined execution commands
- [ ] **Integration**: LSP integration for better error reporting

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a PR.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Heavily inspired by none other than teej[https://github.com/tjdevries] (nvim gawd)
