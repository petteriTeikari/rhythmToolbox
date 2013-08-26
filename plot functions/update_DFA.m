function handles = update_DFA(data_comp, handles)
        
    % use shorter variable names
    alpha       = data_comp.dfa.alpha;
    intervals   = data_comp.dfa.intervals;
    flucts      = data_comp.dfa.flucts;
    offset1     = handles.compSet.dfa_offset;
    alpha_2     = handles.alpha_2;
    offset_2    = handles.offset_2;     

    % subplot 1
    set(handles.figHandles.dfa_p(1), 'XData', intervals, 'YData', flucts)
    set(handles.figHandles.dfa_p(2), 'XData', intervals, 'YData', ((intervals .^ alpha) + offset1))

    % subplot 2
    set(handles.figHandles.dfa_p(3), 'XData', intervals, 'YData', (flucts ./ intervals))
    set(handles.figHandles.dfa_p(4), 'XData', intervals, 'YData', ((intervals .^ alpha_2) + offset_2))       


    