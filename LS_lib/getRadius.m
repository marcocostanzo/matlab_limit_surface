function R = getRadius(fn,params)

if(isscalar(params))
    R = params.delta*fn.^(params.gamma+1);
else
    R = [params.delta]'*fn(:).^([params.gamma]'+1);
end

% gamma = [gamma.gamma]';
% if isscalar(gamma)
%     R = fn.^(gamma+1);
% else
%     R = fn(:).^(gamma+1);
% end

end

