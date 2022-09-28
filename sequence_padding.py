# sequence padding
# tf.keras.preprocessing.sequence.pad_sequence(data, value=words_dict['<PAD>'], max_len=256)
import numpy as np
'''
@param data
@param value
@param length
'''
def pad_sequence(data, value, length):
  # check dimensions
  # dims without batch = (number_of_sequences, seq_length)
  # dims with batch = (batch_Size, number_of_sequences, seq_length)
  def add_padding(data):
    padded_seqs = []
    # loop over all sequences
    for seq in data:
      padded_seq = []
      # loop over each word in sequence
      for i in range(length):
        if (i < len(seq[i])):
          padded_seq.append(seq[i])
        else:
          padded_seq.append(value)
      padded_seqs.append(padded_seq)        
    return padded_seqs

  # if we have batch dimension
  if (data.ndim == 3):
    ret = []
    # loop over all batches
    for batch in data:
      ret.append(add_padding(batch))

  elif (data.ndim == 2):
    ret = add_padding(data)

  elif (data.ndim == 1):
    padded_seq = []
    # loop over each word in sequence
    for i in range(length):
      if (i < len(data)):
        padded_seq.append(data[i])
      else:
        padded_seq.append(value)
    ret = padded_seq
  return np.array(ret)

if __name__ == '__main__':
  sentance = np.array(['hello', 'world', 'whats', 'up'])
  padded = pad_sequence(sentance, '<PAD>', 10)
  print(padded)
