function Filtered=minwindowfilter(Original, WinSize)

    %initialising variables
    WinHalfSize = floor(WinSize/2);
    WinHalfSizePlus = WinHalfSize+1;
    WinSizeSpec = WinSize-1;
    FrontIterator = 1;
    WinPos = WinHalfSize;
    WinMinPos = WinHalfSize;
    WinMin = Original(1);
    OutputIterator = 0;
    
    % Finding the postion of the largest value in window
    for LengthCounter = 0:1:WinHalfSize-1 
        if Original(FrontIterator+1) <= WinMin
            WinMin = Original(FrontIterator+1);
            WinMinPos = WinHalfSizePlus + LengthCounter;
        end
        FrontIterator=FrontIterator+1;
    end
    % if the first point is the highest, set ouput 1
    if WinMinPos == WinHalfSize 
        Filtered1(OutputIterator+1)=WinMin;
    else
        Filtered1(OutputIterator+1)=0;
    end
    OutputIterator = OutputIterator+1;
    
    % search next half of signal
    for LengthCounter = 0:1:WinHalfSize-1 
        if Original(FrontIterator+1) <= WinMin
            WinMin=Original(FrontIterator+1);
            WinMinPos=WinSizeSpec;
        else
            WinMinPos=WinMinPos-1;
        end
        if WinMinPos == WinHalfSize
            Filtered1(OutputIterator+1)=WinMin;
        else
            Filtered1(OutputIterator+1)=0;
        end
        FrontIterator = FrontIterator+1;
        OutputIterator = OutputIterator+1;
    end
    for FrontIterator=FrontIterator:1:length(Original)-1
        if Original(FrontIterator+1) <= WinMin
            WinMin=Original(FrontIterator+1);
            WinMinPos=WinSizeSpec;
        else
            WinMinPos=WinMinPos-1;
            if WinMinPos < 0
                WinIterator = FrontIterator-WinSizeSpec;
                WinMin = Original(WinIterator+1);
                WinMinPos = 0;
                WinPos=0;
                for WinIterator = WinIterator:1:FrontIterator
                    if Original(WinIterator+1) <= WinMin
                        WinMin = Original(WinIterator+1);
                        WinMinPos = WinPos;
                    end
                    WinPos=WinPos+1;
                end
            end
        end
        if WinMinPos==WinHalfSize
            Filtered1(OutputIterator+1)=WinMin;
        else
            Filtered1(OutputIterator+1)=0;
        end
        OutputIterator=OutputIterator+1;
    end
    WinIterator = WinIterator-1;
    WinMinPos = WinMinPos-1;
    for LengthCounter=1:1:WinHalfSizePlus-1
        if WinMinPos<0
            WinIterator=length(Original)-WinSize+LengthCounter;
            WinMin=Original(WinIterator+1);
            WinMinPos=0;
            WinPos=1;
            for WinIterator=WinIterator+1:1:length(Original)-1
                if Original(WinIterator+1) <= WinMin
                    WinMin=Original(WinIterator+1);
                    WinMinPos=WinPos;
                end
                WinPos=WinPos+1;
            end
        end
        if WinMinPos==WinHalfSize
            Filtered1(OutputIterator+1)=WinMin;
        else
            Filtered1(OutputIterator+1)=0;
        end
        FrontIterator=FrontIterator-1;
        WinMinPos=WinMinPos-1;
        OutputIterator=OutputIterator+1;
    end
    Filtered = find(Filtered1);
end
