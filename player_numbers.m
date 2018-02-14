function popNrs = player_numbers(populationSize)

    popNrs = zeros(populationSize,2);
    letters = 'ABCDEFGHIJKLMNOPRSTUVWY';
    
    for i = 1: populationSize

        for j = 1:2

            popNrs(i,j) = char(letters(round(rand * (length(letters)-1))+1));
        end

    end
end
    