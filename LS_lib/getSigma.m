function sigma = getSigma(ft_norm,m_norm,gamma)

if isstruct(gamma)
    gamma = [gamma.gamma]';
end

if isscalar(gamma)
    
    sigma = (ft_norm).^(gamma+1)./(m_norm);
    
else
    
    sigma = zeros(size(ft_norm));
    for i = 1:size(ft_norm,2)
        sigma(:,i) = (ft_norm(:,i)).^(gamma(i)+1)./(m_norm(:,i));
    end
    
end

end

