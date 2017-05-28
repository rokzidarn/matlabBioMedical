% SAMPLE ENTROPY
function entropy=SE(record)
    record = sprintf('%sm.mat', record);
    load(record);
    sig = val(10,:); % preprocessing filter 0.08Hz-4Hz

    len = length(sig);
    tm = (1:length(sig))/20;
    figure; plot(tm(1:len),sig(1:len));

    m = 3; % window length
    r = 0.15; % tolerance

    [e,se,A,B] = sampen(sig,m,r,1,0,0);
    entropy = e(m);
    %disp(['SAMPLE ENTROPY: ' num2str(e(m))]);