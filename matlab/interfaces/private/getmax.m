function maxnum = getmax(data_type, precision)
%GETMAX calls returns a huge number according to `data_type` and `precision`.

callstack = dbstack;
funname = callstack(1).name; % Name of the current function

if nargin < 1 || nargin > 2
    % Private/unexpected error
    error(sprintf('%s:InvalidInput', funname), '%s: UNEXPECTED ERROR: invalid number of inputs.', funname);
else
    if ~ischarstr(data_type)
        % Private/unexpected error
        error(sprintf('%s:InvalidInput', funname), '%s: UNEXPECTED ERROR: invalid data_type received.', funname);
    end
    if nargin == 2 && ~(ischarstr(precision) && ismember(precision, all_precisions()))
        % Private/unexpected error
        error(sprintf('%s:InvalidInput', funname), '%s: UNEXPECTED ERROR: invalid precision received.', funname);
    end
end

if nargin < 2
    precision = 'double';
end

% maxfloat, minfloat, and maxpow10 are intended to the return of the Fortran intrinsics HUGE, TINY,
% and RANGE corresponding to the given precision. They are the largest finite value, the smallest
% positive normalized value, and the decimal exponent range of the floating point numbers, respectively.
if strcmpi(precision, 'single')
    maxfloat = realmax('single');
    minfloat = realmin('single');
else  % Even if precision = 'quadruple'
    maxfloat = realmax('double');
    minfloat = realmin('double');
end
% According to Sec. 16.9.170 of Fortran 2023 Interpretation Document J3/24-007, the Fortran intrinsic
% RANGE returns the following value.
maxpow10 = fix(min(log10(maxfloat), -log10(minfloat)));

% The following values are intended to be consistent with BOUNDMAX, FUNCMAX, and CONSTRMAX defined
% in the Fortran code.
switch lower(data_type)
case {'real'}
    maxnum = maxfloat;
case {'bound'}
    maxnum = 0.25 * maxfloat;
case {'fun', 'func', 'function', 'con', 'constr', 'constraint'}
    maxnum = 10^min(30, floor(maxpow10 / 2));
otherwise
    % Private/unexpected error
    error(sprintf('%s:InvalidInput', funname), '%s: UNEXPECTED ERROR: invalid data_type received.', funname);
end

return
