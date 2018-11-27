function ft_max = getFtMax(fn,mu)

if(isstruct(mu))
    ft_max = [mu.mu]' .* fn(:);
else
    ft_max = mu .* fn;
end

end

