function R = getRadius(fn,gamma)

gamma = [gamma.gamma]';
if isscalar(gamma)
    R = fn.^(gamma+1);
else
    R = fn(:).^(gamma+1);
end

end

