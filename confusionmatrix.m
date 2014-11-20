classdef confusionmatrix < handle
    
    properties
        Matrix
    end

    methods
        function this = confusionmatrix()

            % Initialise the confusion matrix.
            this.Matrix = zeros(6, 6);
        end
        
        function update(this, cbr, inputs, outputs)
            % Test the forest on each entry in the training data, then
            % increment the corresponding element in the matrix.
            for i=1:size(inputs, 1)
                expectedEmotion = outputs(i);
                actualEmotion = 1; % BEN, MAKE THIS WORK!
                this.Matrix(expectedEmotion, actualEmotion) = ...
                        this.Matrix(expectedEmotion, actualEmotion) + 1;
            end
        end
        
        % Functions for part III, these functions calculate the basic
        % properties from the slides;
        
        % Return the accuracy of the matrix.
        function accuracy = getAccuracy(this)
            accuracy = trace(this.Matrix) / sum(this.Matrix(:));
        end

        % Return the recall rate of the given class.
        function recallRate = getRecallRate(this, class)
            recallRate = this.Matrix(class, class) / sum(this.Matrix(class, :));
        end
        
        % Return the precision of the given class.
        function precision = getPrecision(this, class)
            precision = this.Matrix(class, class) / sum(this.Matrix(:, class));
        end
        
        % Return the f score of the given class with parameter alpha.
        function fScore = getFScore(this, class, alpha)
            recallRate = this.getRecallRate(class);
            precision = this.getPrecision(class);
            
            fScore = (1 + alpha^2) * (precision * recallRate) ...
                / (alpha^2 * precision + recallRate);
        end
    end
end
