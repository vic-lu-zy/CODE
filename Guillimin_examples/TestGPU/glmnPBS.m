classdef glmnPBS
    %Guillimin PBS submission arguments
    properties
        % Local script, remote working directory (home, by default)
        localScript = 'TestGPU';
        workingDirectory = '.';

        % nodes, ppn, gpus, phis and other attributes
        numberOfNodes = 1;
        procsPerNode = 1;
        gpus = 1;
        phis = 0;
        attributes = '';

        % Specify the memory per process required
        pmem = '1700m'

        % Requested walltime
        walltime = '00:30:00'

        % Please use metaq unless you require a specific node type
        queue = 'k20'

        % All jobs should specify an account or RAPid:
        % e.g.
        % account = 'xyz-123-aa'
        account = '';

        % You may use otherOptions to append a string to the qsub command
        % e.g.
        % otherOptions = '-M email@address.com -m bae'
        otherOptions = ''
    end

    methods(Static)
        function job = submitTo(cluster)
            opt = glmnPBS();
            job = batch(cluster,    opt.localScript,     ...
                'CurrentDirectory', opt.workingDirectory ...
                );
        end
    end

    methods
        function nbWorkers = getNbWorkers(obj)
            % You may also hard-code the number of workers in case it
            % does not follow the default nodes*ppn-1 rule. For example:
            % nbWorkers = 2;
            nbWorkers = 1;
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





