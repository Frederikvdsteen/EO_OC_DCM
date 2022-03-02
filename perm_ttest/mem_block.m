function [out, num_el, freemem] = mem_block(x,y,Nperm,type,prec_fun);

[r,w] = unix('free | grep Mem');
stats = str2double(regexp(w, '[0-9]*', 'match'));
memsize = stats(1)/1e6;
freemem = (stats(3)+stats(end))/1e6;
scond1 = size(x);
scond2 = size(y);
mat_first = scond1(1);
mat_second = scond1(2);
switch prec_fun
    case 'single'
belem = 4;
    case 'double'
        belem = 8;
end
prec_fun=str2func(prec_fun);
switch type
    case 'paired-ttest'
        num_el = mat_first*mat_second*(scond1(3))*Nperm*3*belem;
        out = ceil((num_el/1e9)/(freemem/1.8));
        
        case 'two-sample-ttest'
       num_el = mat_first*mat_second*(scond1(3)+scond2(3))*Nperm*2*belem;
       out = ceil((num_el/1e9)/(freemem/1.8));
        case 'cluster_size'
            num_el = scond2(1)*scond2(2)*Nperm*2*belem;
            out = ceil((num_el/1e9)/(freemem/1.8));
end

end