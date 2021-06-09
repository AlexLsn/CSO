"""
    linreg(topredict::String, varnames::Vector{Symbol}, train::DataFrame, test::DataFrame, RMSD::Bool=true)

Performs a linear regression with variables from variables and data of D.

# Arguments

- `topredict::String`: The name of the column of the dataframe of interest that is to be predicted.
- `varnames::Vector{Symbol}`: The explanatory variables to include in the regression.
- `train::DataFrame`: The dataset used to train the model.
- `test::DataFrame`: The dataset used to test the model.
- `RMSD::Bool=true`: If true, returns the RMSD of the model. If false, returns the vector of predictions. Default = true.

"""
function linreg(topredict::String, varnames::Vector{Symbol}, train::DataFrame, test::DataFrame, RMSD::Bool=true)
    model = lm(Term(Symbol(topredict)) ~ sum(Term.(varnames)), train)
    predictions = convert(Vector{Float64},GLM.predict(model, test))
    
    RMSD ? (return rmsd(predictions, test[:, Symbol(topredict)])) : return predictions
end