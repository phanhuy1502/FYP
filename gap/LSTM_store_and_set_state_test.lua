require 'torch'
require 'nn'
require 'LanguageModel'
require 'gap/utils'

CHECKPOINT_PATH = 'models/cv/checkpoint_17000.t7'

-- model for sampling
local model = get_model_by_path(CHECKPOINT_PATH)
-- local full_sen = fill_single_gap('Indeed i', 2 ,'was submerged in the water', model)

local opt = {}
opt.gpu = -1
opt.start_text = 'for us'

local sample1 = model:probs(opt)
--model:clearState()

-- trying to forward 'fo' first, get LSTM state, and forward 'rt' later
-- opt.start_text = 'fo'
-- sample = model:probs(opt)

opt.start_text = 'fo'
model:probs(opt)
local LSTM_states = model:getLSTMStates()

-- for layer = 1,#LSTM_states do
--   print (LSTM_states[layer].h:sum())
--   print (LSTM_states[layer].c:sum())
-- end

-- print ('SIZEEEE')
-- print (LSTM_states[1].gates:size())


-- screw up the LSTM layers
model:probs2('aatt')

local sample2 = model:probs2('r us', LSTM_states)
print (torch.equal(sample1,sample2))


-- setting state multiple time
model:probs2('screwing the LSTM')

-- for layer = 1,#LSTM_states do
--   print (LSTM_states[layer].h:sum())
--   print (LSTM_states[layer].c:sum())
-- end

local sample3 = model:probs2('r us', LSTM_states)
print (torch.equal(sample1, sample3))
