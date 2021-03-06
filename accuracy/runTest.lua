require 'gap/multigap'
require 'gap/constants'

-- Run fill in gaps on gerenated test to produce test result
-- test_set: test set generated by generateTestSet
-- Return: test result (include no of trueCount and falseCount)
function runSingleTest (test_set, model, naive, opt, lookforward_length)

	if (opt == nil) then
		opt = {}
		opt.threshold = THRESHOLD
		opt.cutoffprobs = CUT_OFF_PROBS
	end

	-- print ('in runSingleTest')
	-- print (opt)

	local string_with_gap = test_set.string_with_gap
	local solution = test_set.answer

	-- get the test result

	local result
	if naive then
		result = naive_fill_multi_gaps(string_with_gap, test_set.gap_char, model)
		-- print (result)
	else
		result = model:fillMultiGap(string_with_gap, test_set.gap_char, opt, lookforward_length)
	end
	local answer = result[1]

	local trueCount = 0
	local wrongCount = 0

	for count = 1, #answer do
		if (COUNT_PER_SYMBOLS) then
			for symbols_i=1,#answer[count] do
				if (answer[count]:sub(symbols_i,symbols_i) == solution[count]:sub(symbols_i,symbols_i)) then
					trueCount = trueCount + 1
				else
					wrongCount = wrongCount + 1
				end
			end
		else
			if (answer[count] == solution[count]) then
			do
				trueCount = trueCount + 1
			end
			else
				wrongCount = wrongCount + 1
			end
		end
	end

	local test_result = {}
	test_result.wrongCount = wrongCount
	test_result.trueCount = trueCount

	return test_result
end


-- Run fill in gap and generate detail report
-- test_set: test set generated by generateTestSet
-- model: model to test
-- output: pdf file exported to path_to_file (include file name)
-- structure of report file:
-- 	string_with_gap
-- 	filled in string (red for wrong, green for correct)
-- 	accuracy

function generateSingleDetailReport(test_set, path_to_report, model)

	local string_with_gap = test_set.string_with_gap
	local solution = test_set.answer

	-- get the test result
	--local result = fill_multi_gaps2(string_with_gap, test_set.gap_char, model)
	local result = model:fillMultiGap(string_with_gap, test_set.gap_char)

	local answer = result[1]

	local trueCount = 0
	local wrongCount = 0

	-- writing to txt file
	local report = io.open(path_to_report, "w")

	report:write('Passage with missing characters: \n')
	report:write(test_set.numbered_string_with_gap	)

	report:write('\n\nOriginal passage: \n')
	report:write(test_set.original_string	)

	report:write('\n')
	for count = 1, #answer do
		report:write('\nGap no. ' .. count)
		report:write('\nAnswer by model: ' .. answer[count])
		report:write('\nCorrect answer: ' .. solution[count])
		if (answer[count] == solution[count]) then
		do
			trueCount = trueCount + 1
			-- print ('Matched!')
		end
		else
			wrongCount = wrongCount + 1
			-- print ('Not matched!')
		end
	end

	-- compute accuracy
	local accuracy = trueCount/(#answer)*100

	-- print ('Accuracy: ')
	report:write('\n\nAccuracy: ' .. accuracy)
	report:close()

	local result = {}
	result.trueCount = trueCount
	result.total = #answer
	return result
end

--
-- CHECKPOINT_PATH = 'models/cv/checkpoint_17000.t7'
--
-- -- model for sampling
-- local model = get_model_by_path(CHECKPOINT_PATH)
--
-- local gap_char = find_char_to_represent_gap(model)
--
-- -- print (gap_char)
--
-- local testCase = generateTestSet('accuracy/rawTestFiles/testsetgroup1/prof.txt', 'testset', gap_char)
--
-- generateReport(testCase, 'accuracy/reports/prof.txt', model)

-- function generateSingleDetailReport3(test_set, path_to_report, model)
--
-- 	local string_with_gap = test_set.string_with_gap
-- 	local solution = test_set.answer
--
-- 	-- get the test result
-- 	local result = fill_multi_gaps3(string_with_gap, test_set.gap_char, model)
-- 	local answer = result[1]
--
-- 	local trueCount = 0
-- 	local wrongCount = 0
--
-- 	-- writing to txt file
-- 	local report = io.open(path_to_report, "w")
--
-- 	report:write('Passage with missing characters: \n')
-- 	report:write(test_set.numbered_string_with_gap	)
--
-- 	report:write('\n\nOriginal passage: \n')
-- 	report:write(test_set.original_string	)
--
-- 	report:write('\n')
-- 	for count = 1, #answer do
-- 		report:write('\nGap no. ' .. count)
-- 		report:write('\nAnswer by model: ' .. answer[count])
-- 		report:write('\nCorrect answer: ' .. solution[count])
-- 		if (answer[count] == solution[count]) then
-- 		do
-- 			trueCount = trueCount + 1
-- 			-- print ('Matched!')
-- 		end
-- 		else
-- 			wrongCount = wrongCount + 1
-- 			-- print ('Not matched!')
-- 		end
-- 	end
--
-- 	-- compute accuracy
-- 	local accuracy = trueCount/(#answer)*100
--
-- 	-- print ('Accuracy: ')
-- 	report:write('\n\nAccuracy: ' .. accuracy)
-- 	report:close()
--
-- 	local result = {}
-- 	result.trueCount = trueCount
-- 	result.total = #answer
-- 	return result
-- end
