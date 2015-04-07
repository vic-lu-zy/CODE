classdef glmnPBS
    %Guillimin PBS submission arguments
    properties
        % Local script, remote working directory (home, by default)
        localScript = 'decode_sac_dir';
        workingDirectory = '/home/lzvic/gs/20100412/';

        % nodes, ppn, gpus, phis and other attributes
        numberOfNodes = 1;
        procsPerNode = 16;
        gpus = 0;
        phis = 0;
        attributes = '';

        % Specify the memory per process required
        pmem = '1800m'

        % Requested walltime
        walltime = '00:30:00'

        % Please use metaq unless you require a specific node type
        queue = 'metaq'

        % All jobs should specify an account or RAPid:
        % e.g.
        % account = 'xyz-123-aa'
        account = 'wns-454-aa';

        % You may use otherOptions to append a string to the qsub command
        % e.g.
        % otherOptions = '-M email@address.com -m bae'
        otherOptions = ''
    end

    methods(Static)
        function job = submitTo(cluster)
            opt = glmnPBS();
            job = batch(cluster,    opt.localScript,     ...
                'matlabpool',       opt.getNbWorkers(),  ...
                'CurrentDirectory', opt.workingDirectory ...
                );
        end
    end

    methods
        function nbWorkers = getNbWorkers(obj)
            % You may also hard-code the number of workers in case it
            % does not follow the default nodes*ppn-1 rule. For example:
            % nbWorkers = 2;
            nbWorkers = obj.numberOfNodes * obj.procsPerNode - 1;
        end

        function submitArgs = getSubmitArgs(obj)
            pbsAccount = '';
            if size(obj.account) > 0
                pbsAccount = sprintf('-A %s', obj.account);
            end

            compRes = sprintf('nodes=%d:ppn=%d', obj.numberOfNodes, obj.procsPerNode);

            if obj.gpus > 0
                compRes = sprintf('%s:gpus=%d', compRes, obj.gpus);
            end

            if obj.phis > 0
                compRes = sprintf('%s:phis=%d', compRes, obj.phis);
            end

            if not(isempty(obj.attributes))
                compRes = sprintf('%s:%s', compRes, obj.attributes);
            end

            compRes = sprintf('%s -l pmem=%s -l walltime=%s', compRes, obj.pmem, obj.walltime);

            nLicenses = obj.getNbWorkers() + 1;

            submitArgs = sprintf('%s -q %s -l %s -W x=GRES:MATLAB_Distrib_Comp_Engine:%d %s', ...
                pbsAccount, obj.queue, compRes, nLicenses, obj.otherOptions);
        end
    end
end





