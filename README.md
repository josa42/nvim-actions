# Nvim Actions

## Usage

```lua
require('jg.actions').map('*', function(str) 
  return string.gsub(str, '[^ ]', '*')
end)
```

## License

[MIT © Josa Gesell](LICENSE)
