app <- ShinyDriver$new("../")
app$snapshotInit("mytest")

# Input '`.clientValue-plotly_relayout-A`' was set, but doesn't have an input binding.
# Input '`.clientValue-plotly_relayout-A`' was set, but doesn't have an input binding.
app$setInputs(LIB3 = "JEFF-3.2")
app$setInputs(LIB3 = c("JEFF-3.2", "JEFF-3.0"))
app$setInputs(LIB3 = c("JEFF-3.2", "JEFF-3.0", "JEFF-3.3"))
app$snapshot()
