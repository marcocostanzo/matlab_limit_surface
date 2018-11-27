function J = minForceJcst( fn , ls_norm_fcn, ft, taun, params )

fn = abs(fn);
if fn == 0
    J = 10;
    return
end
ft = abs(ft);
taun = abs(taun);

ft_norm = min(ft/getFtMax(fn,params.mu), 1.0);

J = ls_norm_fcn(ft_norm) - taun/getTaunMax(fn, params);
end