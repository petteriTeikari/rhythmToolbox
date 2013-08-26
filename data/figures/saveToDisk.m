function saveToDisk(fig, fileNameOut, style)

    %% Use export_fig to save as PNG    
    try
        export_fig(fileNameOut, style.imgOutRes, style.imgOutAntiAlias)                
        
    catch err
        
        if strcmp(err.identifier, 'MATLAB:UndefinedFunction')    
            warningString = sprintf('%s\n%s', 'lightLab uses 3rd party export_fig as default for saving figures on disk as the quality is better than with in-built function', ...
                                    'Download and add to path from: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig');
            warning(warningString)
            warning('Saving however now using the built-in function')
            saveas(fig, [strrep(fileNameOut, '.png', ''), '_inBuilt'], 'png'); %name is a string

        else
            error(err.identifier)
            
        end
        
    end
    
    %% SVG?
    
    
    %% EPS?