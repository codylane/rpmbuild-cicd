if [ -d /opt/ruby/2.5.8/bin/ ]; then
  (echo "$PATH" | grep -q "/opt/ruby/2.5.8/bin/") || export PATH="/opt/ruby/2.5.8/bin/:${PATH}"
fi
