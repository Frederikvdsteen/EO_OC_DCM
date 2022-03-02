function [out] = t_map(x,y,type) 
%%t_map(x,y,type) 
%%x = condition1
%%y=condition2
%%type: 'paired-ttest';'two-sample-ttest';'one-sample'




scond1 = size(x);
scond2 = size(y);

switch type
    case 'paired-ttest'
        diff_orig = bsxfun(@minus,x,y);
        denom = std(diff_orig,0,3)./sqrt(scond1(3));
        out = bsxfun(@rdivide,mean(diff_orig,3),denom);
    case 'two-sample-ttest'
        num_t = mean(x,3) - mean(y,3);
        den_t = sqrt(var(x,[],3)/scond1(3) + var(y,[],3)/scond2(3));
        out = num_t./den_t;
    case 'one-sample'
        m_x = mean(x,3);
        num_t = m_x-y;
        denom = std(x,[],3)/sqrt(scond1(3));
        out = num_t./denom;
end

end