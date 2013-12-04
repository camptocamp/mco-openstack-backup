metadata :name        => "fsfreeze",
         :description => "Fsfreeze agent",
         :author      => "Raphael Pinson",
         :license     => "GPLv3+",
         :version     => "0.1",
         :url         => "",
         :timeout     => 60

action "fsfreeze", :description => "Freeze a file system" do
  input :filesystem,
        :prompt      => "File system",
        :description => "The file system to freeze",
        :type        => :string,
        :validation  => '^(/|ALL$)',
        :optional    => false,
        :maxlength   => 30

  input :unfreeze_after,
        :prompt      => "Unfreeze after",
        :description => "Number of seconds to wait before automatic unfreeze",
        :type        => :number,
        :optional    => true

  output :msg,
         :description => "The output status",
         :display_as  => "Message"
end

action "fsunfreeze", :description => "Unfreeze a file system" do
  input :filesystem,
        :prompt      => "File system",
        :description => "The file system to unfreeze",
        :type        => :string,
        :validation  => '^(/|ALL$)',
        :optional    => false,
        :maxlength   => 30

  output :msg,
         :description => "The output status",
         :display_as  => "Message"
end
