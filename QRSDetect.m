function [idx] = QRSDetect(fileName,m,window,alpha,gamma) % Chen ECG
    % parameters:
    % m = moving average, best: 5 or 7 (odd numbers)
    % window = window width, used for summation and peak exclusion
    % alpha = forgetting factor (0 <= alpha <= 1)
    % gamma = weighting factor (0.15 <= gamma <= 0.2)

    % Chen ECG

     % algorithm
    load (fileName); % load signal, record
    rawSignal = val(1,:); % save signal
    signalLength = length(rawSignal);
    %plot(rawSignal, 'r'); title('Raw'); figure;

    % ---------------------------------------------------------------------------linear HP filter (1)
    % y[n] = y2[n]-y1[n] = delay - moving average

    % m-point moving average (1.1)
        % y1[n] = (1/m)*(sum[1...N-1](x[n-m]))
    b = ones(1,m)*(1/m); % moving average coefficients, nulls
    a = 1; % poles

    filteredSignal = filter(b,a,rawSignal);
    %plot(filteredSignal, 'g'); title('MAF'); figure;

    % delay (1.2)
        % y2[n] = x[n-(m+1)/2]

    delayedSignal = zeros(1,signalLength);
    for d = ((m+1)/2)+1:signalLength;
        delayedSignal(d) = filteredSignal(d-((m+1)/2));
    end

    % MAF
        % y[n] = y2[n] - y1[n]
    for y = 1:signalLength;
        filteredSignal(y) = delayedSignal(y) - filteredSignal(y);
    end
    %plot(filteredSignal, 'r'); title('LP filter'); figure;

    % ---------------------------------------------------------------------------non-linear LP filter (2)
    % point to point square operation (^2) -> summation system (sum())

    % point to point squaring (2.1)
    for x = 1:signalLength;
        filteredSignal(x) = filteredSignal(x).^2; % makes values positive & amplifies them
    end
    %plot(filteredSignal, 'g'); title('Square operation'); figure; 

    % summation system (2.2)
        % window width: dependant on number of samples
        % e.g. 200Hz -> 30 samples
        % xform command - resample to desired sampling frequency

    final = filteredSignal;
    for x = window+1:signalLength
       sum = 0;
       for z = x-window:x   
           sum = sum + final(z);
       end
       final(x-window) = sum;
    end
    %plot(final,'b'); title('HP filter'); figure

    % bxb command: bxb -r s20011 -a atr qrs

    % --------------------------------------------------------------------decision making (3)
    % threshold = alpha*gamma*peak + (1-alpha)*threshold

    threshold = 1;
    peak = max([final(1), final(2), final(3)]); % local maximum
    threshold = alpha*gamma*peak + (1-alpha)*threshold; % if exceeds QRS complex is detected, heartbeat

    peaks = [];
    idx = []; % indexes of heartbeats
    p = 0; % to check when peaks above threshold ends

    for x = 3:1:signalLength-1
        peak = max([final(x-1), final(x), final(x+1)]);
        if(peak > threshold)   
            p = 1;
            threshold = alpha*gamma*peak + (1-alpha)*threshold;
            peaks = [peaks, x];
        else
            if(p == 1)
                heartbeat = round(mean(peaks));
                idx = [idx, heartbeat];
                peaks = [];
            end
            p = 0;
        end
    end

    %plot(final,'b'); title('Final'); hold on; plot(idx, 0, 'r*'); hold on;
    %disp(idx);
end