function fish_prompt
  set -l user_color (set_color green)
  set -l host_color (set_color cyan)
  set -l path_color (set_color magenta)
  set -l normal_color (set_color normal)

  echo -n -s $user_color (whoami) $normal_color @ $host_color (hostnamectl --static) ' ' $path_color (prompt_pwd) $normal_color ' > '
end
