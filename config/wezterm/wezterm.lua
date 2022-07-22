local wezterm = require 'wezterm';

return {
  font = wezterm.font("Iosevka Nerd Font Mono"),
  color_scheme = "Rosé Pine (base16)";
    ssh_domains = {
    {
      -- This name identifies the domain
      name = "rs21",
      -- The hostname or address to connect to. Will be used to match settings
      -- from your ssh config file
      remote_address = "rs21.furiosa.org",
      -- The username to use on the remote host
      username = "root",
    }
  }
}
