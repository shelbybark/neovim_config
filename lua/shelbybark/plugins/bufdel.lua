return {
    "ojroques/nvim-bufdel",
    config = function()
        local bufdel = require('bufdel')
        bufdel.setup {
          next = 'tabs',
          quit = false,  -- quit Neovim when last buffer is closed
        }
    end,
}   
