@testset "chosenVariables.jl" begin

    data_surv = CSO.dataset("cso_raw")
    data_trudeau = CSO.dataset("Montreal-Trudeau_15min_precipitations")
    data = innerjoin(data_surv, data_trudeau, on=:Date)
    dropmissing!(data, :Duration)

    varnames = [:d15min, :d1h]
    topredict = "Duration"

    train, test = train_test_year(data, 2020)

    model = lm(Term(Symbol(topredict)) ~ sum(Term.(varnames)), train)
    predictions = convert(Vector{Float64}, GLM.predict(model, test))

    RMSD = rmsd(predictions, test[:, Symbol(topredict)])

    #The RMSD is well derived
    @test RMSD == linreg("Duration", [:d15min, :d1h], train, test)

    #Predictions are well derived
    @test predictions == linreg("Duration", [:d15min, :d1h], train, test, false)

end
