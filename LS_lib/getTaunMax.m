function m_max = getTaunMax(fn, params)

% if isscalar(params)
%     m_max = 2*params.mu.*getCkNik(params.k).*params.beta.*fn.*getRadius(fn,params);
% else
%     m_max = 2*[params.mu]'.*getCkNik([params.k]').*[params.beta]'.*fn(:).*getRadius(fn,params);
% end

if isscalar(params)
    m_max = 2*params.mu.*getCkNik(params.k)*fn.*getRadius(fn,params);
else
    m_max = 2*[params.mu]'.*getCkNik([params.k]').*fn(:).*getRadius(fn,params);
end


end

