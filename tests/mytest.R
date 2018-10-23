app <- ShinyDriver$new("../")
app$snapshotInit("mytest")

app$setInputs(LIB3 = "JEFF-3.3")
app$setInputs(LIB3 = c("JEFF-3.3", "ENDFB-VIII.b4"))
app$snapshot(list(output = "plot_cumul"))
