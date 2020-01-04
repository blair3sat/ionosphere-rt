function ionort( default, ionort_model )
%IONORT - Ionosphere Ray Tracing
%   Detailed explanation goes here

format long;

% Path of additional libraries /functions
path(path, 'lib');
path(path, 'lib\export_fig');

%
main = struct2cell(default.main);
options = struct2cell(default.options);
parameters = struct2cell(default.parameters);

% Creation of the variable file necessary for the Fortran program
fid = fopen('source\DATA_IN.txt','w');
fprintf(fid, '%10.10f\n', str2double(main));
fprintf(fid, '%10.10f\n', str2double(options));
fprintf(fid, '%10.10f\n', str2double(parameters));
fclose(fid);

% Run ionort.exe program in the 'source' folder
oldFolder = cd('source');   
[status,result] = system( ['ionort_', ionort_model] );
cd(oldFolder);

% Converting output to a numerical matrix
coordinates = str2num(result);

% Elimination of duplicates (lines with equal coordinates)
coordinates( find( diff(coordinates(:,1) ) == 0 & diff(coordinates(:,2) ) == 0 & diff(coordinates(:,3) ) == 0 ), : ) = [];

% Search for the special coordinate "0 0 0": closing flag of each beam
split_coordinates = find( coordinates(:,1) == 0 & coordinates(:,2) == 0 & coordinates(:,3) == 0 );

% CYCLE FOR EVERY RAY FOUND
for i = 0 : length( split_coordinates ) - 1
    
    if ( length( split_coordinates ) == 1 )
        % the radius is only one, there is no need to divide it
        coordinate = coordinates;
    else
        
        if ( i == 0 )
            start_coordinate = 1;
        else
            start_coordinate = split_coordinates(i)+1;
        end
        
        if ( length( split_coordinates ) == i )
            end_coordinate = length( coordinates );
        else
            end_coordinate = split_coordinates(i+1);
        end
        
        coordinate = coordinates( start_coordinate : end_coordinate, : );
        
    end
    
    % Special radius coordinates
    %* NOTA: IONO IN NON DOVREBBE ESSERE - 1 *%
    ray_ionoin = find(coordinate(:,1) == 111.1 & coordinate(:,3) == 1) - 1; % RAY IN THE IONOSPHERE
    ray_apogee = find(coordinate(:,1) == 111.1 & coordinate(:,3) == 2) - 1; % APOGEE
    ray_ionoout = find(coordinate(:,1) == 111.1 & coordinate(:,3) == 3) - 1; % RAY OUT THE IONOSPHERE
    
    % Special coordinates of critical cases
    case_penetrate = find(coordinate(:,1) == 222.2 & coordinate(:,3) == 0); % RAY PENETRATE
    case_closest = find(coordinate(:,1) == 222.2 & coordinate(:,3) == 1); % CLOSEST APPROACH : MIN. DIST.
    case_reflection = find(coordinate(:,1) == 222.2 & coordinate(:,3) == 2); % GROUND REFLECTION
    case_integration = find(coordinate(:,1) == 222.2 & coordinate(:,3) == 3); % INTEGRATION FAILURE
    
    % Special coordinates of critical cases
    result_groupdelay = coordinate( find(coordinate(:,1) == 333.3 & coordinate(:,3) == 1), 2 ); % GROUP DELAY
    result_grouppath = coordinate( find(coordinate(:,1) == 333.3 & coordinate(:,3) == 2), 2 ); % GROUP PATH
    result_plasmafreq = coordinate( find(coordinate(:,1) == 333.3 & coordinate(:,3) == 3), 2 ); % TRANSMITTER IN EVANESCENT REGION: CRITICAL PLASMAFREQUENCY

    % Deleting rows with particular values
    OPTIMIZABLE%: I already know which lines to remove
    coordinate( find( coordinate(:,1) == 0 & coordinate(:,2) == 0 & coordinate(:,3) == 0 ), :) = [];
    coordinate( find( coordinate(:,1) == 111.1 ), :) = [];
    coordinate( find( coordinate(:,1) == 222.2 ), :) = [];
    coordinate( find( coordinate(:,1) == 333.3 ), :) = [];
    
    % correction due to shifting of coordinates afterwards
    % the elimination of special points.
    if( ~isempty( ray_ionoin ) )
        if( ~isempty( ray_apogee ) ) ray_apogee = ray_apogee - 1; end
        if( ~isempty( ray_ionoout ) ) ray_ionoout = ray_ionoout - 2; end
    end
    if( ~isempty( ray_apogee ) )
        if( ~isempty( ray_ionoout ) ) ray_ionoout = ray_ionoout - 1; end
    end
    
    % SIGNIFICANT CASE critical plasma frequency: the beam does not start
    if( ~isempty( result_plasmafreq ) )
        
        doPlot = false;
        
        h = findobj('Tag', 'result_plasmafreq');
        set(h, 'String', result_plasmafreq );
        
    else
        
        doPlot = true;

        % Reading columns
        rho = coordinate(:,1);
        phi = coordinate(:,2);
        theta = coordinate(:,3);

        % Conversion and adaptation of values
        radius = rho .* 1000;
        lat = degrees( pi/2 - phi );
        lon = degrees( theta );

        % Results: latitude, longitude, apogee (km), group delay (ms), group route (km)
        h = findobj('Tag', 'result_latitude');
        set(h, 'String', lat( length(lat) ) );

        h = findobj('Tag', 'result_longitude');
        set(h, 'String', lon( length(lon) ) );

        if( ~isempty( ray_apogee ) )
            h = findobj('Tag', 'result_apogee');
            set(h, 'String', coordinate( ray_apogee ) - str2num( default.main.earthr ) );
        end

        if( ~isempty( result_groupdelay ) )
            h = findobj('Tag', 'result_groupdelay');
            set(h, 'String', result_groupdelay );
        end

        if( ~isempty( result_grouppath ) )
            h = findobj('Tag', 'result_grouppath');
            set(h, 'String', result_grouppath );
        end
        
    end

    % parameters and results for the string
    frequency = num2str( str2double( default.main.fbeg ) + str2double( default.main.fstep ) * i );
    elevation = num2str( degrees( str2double( default.main.elbeg ) + str2double( default.main.elstep ) * i ) );
    azimuth = num2str( degrees( str2double( default.main.azbeg ) + str2double( default.main.azstep ) * i ) );
    transmitter = num2str( str2double( default.main.xmtrh ) );
    receiver = num2str( str2double( default.main.rcvrh ) );
    lat_start = num2str( degrees( str2double( default.main.tlat ) ) );
    lon_start = num2str( degrees( str2double( default.main.tlon ) ) );
    ray_apogee = coordinate( ray_apogee ) - str2num( default.main.earthr );
    if ( default.main.ray == '-1' ) ray_extra = ' - RayExtra'; else ray_extra = ''; end

    % Text string with results
    stringa = ['MAIN PARAMETERS \n', ...
               '----------------------- \n', ...
               'Latitude    = ', lat_start, ' N \n', ...
               'Longitude   = ', lon_start, ' E \n', ...
               'Frequency   = ', frequency, ' MHz \n', ...
               'Elevation   = ', elevation, ' Degrees \n', ...
               'Azimuth     = ', azimuth, ' Degrees \n', ...
               'Transmitter = ', transmitter, ' km \n', ...
               'Receiver    = ', receiver, ' km \n\n', ...
               'RESULTS \n', ...
               '----------------------- \n'];
    
    if( ~isempty( result_plasmafreq ) )
        stringa = [stringa 'Critical plasma frequency  = ', num2str( result_plasmafreq ), ' MHz \n'];
    else
        stringa = [ stringa, ...
               'Latitude    = ', num2str( lat( length(lat) ) ), ' N \n', ...
               'Longitude   = ', num2str( lon( length(lon) ) ), ' E \n'];
    end
    
    if( ~isempty( ray_apogee ) )      
        stringa = [stringa, 'Apogee      = ', num2str( ray_apogee ), ' km \n'];
    end
    if( ~isempty( result_groupdelay ) )
        stringa = [stringa, 'Group delay = ', num2str( result_groupdelay ), ' ms \n'];
    end
    if( ~isempty( result_grouppath ) )
        stringa = [stringa 'Group path  = ', num2str( result_grouppath ), ' km \n'];
    end
    if( ~isempty( case_penetrate ) )
        stringa = [stringa '\nRAY PENETRATE !!!'];
    end
    if( ~isempty( case_closest ) )
        stringa = [stringa '\nCLOSEST APPROACH: MIN. DIST.!!!'];
    end
    if( ~isempty( case_reflection ) )
        stringa = [stringa '\nGROUND REFLECTION !!!'];
    end
    if( ~isempty( case_integration ) )
        stringa = [stringa '\nINTEGRATION FAILURE !!!'];
    end
    
    % Name of the file to be saved in the /results folder
    filename = ['results\LAT ', lat_start, ' - LON ', lon_start, ' - FR ', frequency, ' - EL ', elevation, ' - AZ ', azimuth, ' - Tx ', transmitter, ' - Rx ', receiver, ' - ', ionort_model, ray_extra];
           
    % Saving result string
    dlmwrite( [ filename, '.txt' ], ...
              sprintf(stringa), 'delimiter', '', 'newline', 'pc');
    
    %% Saving simple output variables
    % eval(['save ' [filename,'.num'] ' final_lat final_long apogee group_delay group_path -ascii']);


    if( doPlot )
        
        %% 3D visualization

        % Focus on the figure representing the Earth
        h = findobj('Tag', 'earth');
        set(gcf,'CurrentAxes', h);

        hold on;

        % Conversion from spherical to Cartesian coordinates
        [x1,y1,z1] = sph2xyz(radians(lon), radians(lat), radius);

        lonpos = lon(1) + 90;

        % Zoom and Centering
        set( gca, 'CameraTargetMode', 'manual', 'CameraTarget', [x1(1) y1(1) z1(1)], 'CameraViewAngle', 2.5 );
        view([lonpos lat(1)]);
        %set(gca,'CameraPositionMode','manual','CameraPosition',[sin(radians(lonpos))*sin(radians(lat(1)))*110585300 -cos(radians(lonpos))*cos(radians(lat(1)))*110585300 71082900]);

        % Full radius
        plot3( x1, y1, z1, ...
              '-w', ...
              'LineWidth', 1);

        % Ray starts and arrives under the ionosphere
        if( ~isempty(ray_ionoin) && ~isempty(ray_ionoout) )

            % Colored ray in the ionosphere
            plot3( x1( ray_ionoin : ray_ionoout ), ...
                   y1( ray_ionoin : ray_ionoout ), ...
                   z1( ray_ionoin : ray_ionoout ), ...
                  ':y', ...
                  'LineWidth', 2);

        % Ray starts from above the ionosphere but reaches the receiver on the ground
        elseif( isempty(ray_ionoin) && ~isempty(ray_ionoout) )

            % Colored ray in the ionosphere
            plot3( x1( 1 : ray_ionoout ), ...
                   y1( 1 : ray_ionoout ), ...
                   z1( 1 : ray_ionoout ), ...
                  ':y', ...
                  'LineWidth', 2);

        % Radius starts from under the ionosphere and the hole
        elseif( ~isempty(ray_ionoin) && isempty(ray_ionoout) )

            % Colored ray in the ionosphere
            plot3( x1( ray_ionoin : length(x1) ), ...
                   y1( ray_ionoin : length(y1) ), ...
                   z1( ray_ionoin : length(z1) ), ...
                  ':y', ...
                  'LineWidth', 2);

        % Radius starts from above the ionosphere and never reaches the ground
        elseif( isempty(ray_ionoin) && isempty(ray_ionoout) )

            % Colored ray in the ionosphere
            plot3( x1( 1 : length(x1) ), ...
                   y1( 1 : length(y1) ), ...
                   z1( 1 : length(z1) ), ...
                  ':y', ...
                  'LineWidth', 2);

        end

        % Start point
        plot3( x1(1), y1(1), z1(1), ...
              'ks', ...
              'MarkerFaceColor', [0 1 0], ...
              'MarkerSize', 8);

        % Exit point
        if( ~isempty(ray_ionoout) )

            % under the ionosphere
            plot3( x1( length(x1) ), y1( length(y1) ), z1( length(z1) ), ...
                  'rx', ...
                  'MarkerFaceColor', [1 0 0], ...
                  'MarkerSize', 10);
            plot3( x1( length(x1) ), y1( length(y1) ), z1( length(z1) ), ...
                  'rd', ...
                  'MarkerFaceColor', [1 0 0], ...
                  'MarkerSize', 4);

        else

            % inside the ionosphere and beyond
            plot3( x1( length(x1) ), y1( length(y1) ), z1( length(z1) ), ...
                  'r^', ...
                  'MarkerFaceColor', [1 1 1], ...
                  'MarkerSize', 5);

            OUTPUT MARKER

        end

        %% 2D Piano Azimuthale

        zoom on;

        % Ground clearance in km
        altitude = ( radius - str2num( default.main.earthr ) * 1000 ) ./ 1000;

        % Focus on the figure
        h = findobj('Tag','az');
        set(gcf,'CurrentAxes',h);

        [x,y] = Spherical2AzimuthalEquidistant(lat, lon, lat(1), lon(1), 0, 0, radius(1));

        box('on');

        hold on;

        ray = sqrt( x.^2 + y.^2 ) / ( 100 * pi );

        %%% PLOT

        % Ray starts from under the ionosphere and returns to the ground
        if( ~isempty(ray_ionoin) && ~isempty(ray_ionoout)  )

            plot( ray( 1 : ray_ionoin ), ...
                  altitude( 1 : ray_ionoin ) );

            cline( ray( ray_ionoin : ray_ionoout ), ...
                   altitude( ray_ionoin : ray_ionoout ));

            plot( ray( ray_ionoout : length(ray) ), ...
                  altitude( ray_ionoout : length(altitude) ) );

         % Radius starts from under the ionosphere and the hole
        elseif( ~isempty(ray_ionoin) && isempty(ray_ionoout) )

            plot( ray( 1 : ray_ionoin ), ...
                  altitude( 1 : ray_ionoin ) );

            cline( ray( ray_ionoin : length(ray) ), ...
                   altitude( ray_ionoin : length(altitude) ));

        % Ray starts from above the ionosphere but reaches the receiver on the ground
        elseif( isempty(ray_ionoin) && ~isempty(ray_ionoout) )

            cline( ray( 1 : ray_ionoout ), ...
                   altitude( 1 : ray_ionoout ));

            plot( ray( ray_ionoout : length(ray) ), ...
                  altitude( ray_ionoout : length(altitude) ) );

        % Radius starts from above the ionosphere and never reaches the ground
        elseif( isempty(ray_ionoin) && isempty(ray_ionoout) )

            cline( ray( 1 : length(ray) ), ...
                   altitude( 1 : length(altitude) ));

        end

        %%% MARKER

        % Transmitter
        mark_trans = plot( ray(1), altitude(1), ...
                           'ks', ...
                           'MarkerFaceColor', [0 1 0]);

        legenda_punti = [ mark_trans ];
        legenda_label = {'Transmitter'};

        % Entry point into the ionosphere
        if( ~isempty(ray_ionoin) )
            mark_in = plot( ray( ray_ionoin ), altitude( ray_ionoin ), ...
                            'bo', ...
                            'MarkerSize', 4, ...
                            'MarkerFaceColor', [0 0 1] );
            legenda_punti = [ legenda_punti, mark_in ];
            legenda_label = [ legenda_label, {'Ionosphere IN'} ];
        end


        % Exit point from the ionosphere
        if( ~isempty(ray_ionoout) )
            mark_out = plot( ray( ray_ionoout ), altitude( ray_ionoout ), ...
                             'bo', ...
                             'MarkerSize', 4, ...
                             'MarkerFaceColor', [1 1 1] );
            legenda_punti = [ legenda_punti, mark_out ];
            legenda_label = [ legenda_label, {'Ionosphere OUT'} ];
        end

        if( isempty( case_closest ) && isempty( case_reflection ) && isempty( case_integration ) )
            
            if( isempty( case_penetrate ) )
                % Receiver
                mark_receiver = plot( ray( length(ray) ), altitude( length(altitude) ), ...
                                      'rx', ...
                                      'MarkerFaceColor', [1 0 0], ...
                                      'MarkerSize', 8 );
                legenda_punti = [ legenda_punti, mark_receiver ];
                legenda_label = [ legenda_label, {'Receiver'} ];
            else
                % Penetration
                mark_penetration = plot( ray( length(ray) ), altitude( length(altitude) ), ...
                                      'r^', ...
                                      'MarkerFaceColor', [1 0 0], ...
                                      'MarkerSize', 8 );
                legenda_punti = [ legenda_punti, mark_penetration ];
                legenda_label = [ legenda_label, {'Penetration'} ];
            end
            
        else
            if( ~isempty( case_closest ) )
                mark_closest = plot( ray( length(ray) ), altitude( length(altitude) ), ...
                                  'r*', ...
                                  'MarkerFaceColor', [1 0 0], ...
                                  'MarkerSize', 8 );
                legenda_punti = [ legenda_punti, mark_closest ];
                legenda_label = [ legenda_label, {'Closest approach'} ];
            elseif( ~isempty( case_reflection ) )
                mark_reflection = plot( ray( length(ray) ), altitude( length(altitude) ), ...
                                  'rd', ...
                                  'MarkerFaceColor', [1 0 0], ...
                                  'MarkerSize', 8 );
                legenda_punti = [ legenda_punti, mark_reflection ];
                legenda_label = [ legenda_label, {'Ground reflection'} ];
            elseif( ~isempty( case_integration ) )
                mark_integration = plot( ray( length(ray) ), altitude( length(altitude) ), ...
                                  'r>', ...
                                  'MarkerFaceColor', [1 0 0], ...
                                  'MarkerSize', 8 );
                legenda_punti = [ legenda_punti, mark_integration ];
                legenda_label = [ legenda_label, {'Integration failure'} ];
            end
        end


        % Legend
        legend( legenda_punti, legenda_label );

    end
    
end
