module MCollective
  module Agent
    class Fsfreeze<RPC::Agent
      def getallfs
        require 'augeas'
        Augeas.open(nil, '/', Augeas::NO_MODL_AUTOLOAD) do |aug|
          aug.transform(
            :lens => 'Fstab.lns',
            :name => 'Fstab',
            :incl => ['/etc/mtab'],
            :excl => []
          )
          aug.load!
          aug.match('/files/etc/mtab/*/file').map { |p| aug.get(p) }
        end
      end

      def run_freeze(action, filesystem)
        allfs = (filesystem == 'ALL') ? getallfs : [filesystem]
        allfs.each do |f|
          case action
            when :freeze
              next if f =~ /^\/tmp/  # Do not freeze /tmp or mcollective will freeze, too
              run("fsfreeze -f #{f}", :stdout => :out, :stderr => :err)
              sleep = request[:unfreeze_after] || 30
              run("sleep #{sleep} && fsfreeze -u #{f} &", :stdout => :out, :stderr => :err)
            when :unfreeze
              run("fsfreeze -u #{f}", :stdout => :out, :stderr => :err)
            else
              fail "Wrong action #{action}"
          end
        end
      end

      action "fsfreeze" do
        validate :filesystem, String
        reply[:msg] = run_freeze(:freeze, request[:filesystem])
      end

      action "fsunfreeze" do
        validate :filesystem, String
        reply[:msg] = run_freeze(:unfreeze, request[:filesystem])
      end
    end
  end
end
