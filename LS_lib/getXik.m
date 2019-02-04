function Xi_k = getXik( k )

Xi_k = (3/2)*k.*(gamma(3./k))./( gamma(1./k) .* gamma(2./k) );

%Xi_k = k / (2* beta(2/k , 1/k + 1) );

end

