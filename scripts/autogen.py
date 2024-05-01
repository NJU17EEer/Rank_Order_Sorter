
from scipy.special import comb
import numpy as np

inputVar = 'mag_in' # unsigned
inputVarWidth = 4
inputsNum = 4
outputVar = 'min_out' # unsigned
filename = "rank_order_sorter.sv"

outputVarWidth = inputVarWidth
outputsNum = int(inputsNum / 2)
f = open(filename, 'w')

# comparison stage
f.write('// comparison stage\n')
realCmpBitVar = 'cmp_out'
realCmpBitsNum = int(comb(inputsNum, 2))
f.write(f'wire [{realCmpBitsNum - 1}:0] {realCmpBitVar};\n')

idx = 0
mapMat = np.zeros((inputsNum, inputsNum), dtype=int)
for i in range(inputsNum):
    for j in range(i + 1, inputsNum):
        mapMat[i][j] = idx
        f.write(f'assign {realCmpBitVar}[{idx}] = '
                f'{inputVar}[{i}] < {inputVar}[{j}] ? 1\'b0 : 1\'b1;\n')
        idx += 1
print(mapMat)

cmpBitVar = 'cmp_bit'
cmpBitsNum = inputsNum - 1
f.write(f'wire [{cmpBitsNum - 1}:0] {cmpBitVar} [0:{inputsNum - 1}];\n')
for i in range(inputsNum):
    idx = 0
    for j in range(inputsNum):
        if i < j:
            f.write(f'assign {cmpBitVar}[{i}][{idx}] = '
                    f'{realCmpBitVar}[{mapMat[i][j]}];\n')
        elif i > j:
            f.write(f'assign {cmpBitVar}[{i}][{idx}] = '
                    f'~{realCmpBitVar}[{mapMat[j][i]}];\n')
        else:
            idx -= 1

        idx += 1
# rank computation stage
f.write('// rank computation stage\n')
rankVar = 'rank'
rankWidth = int(np.log2(inputsNum))
f.write(f'wire [{rankWidth - 1}:0] {rankVar} [0:{inputsNum - 1}];\n')
for i in range(inputsNum):
    f.write(f'assign {rankVar}[{i}] = ')
    for j in range(inputsNum - 1):
        if j < (inputsNum - 2):
            f.write(f'{cmpBitVar}[{i}][{j}] + ')
        else:
            f.write(f'{cmpBitVar}[{i}][{j}];\n')

# selection stage
f.write('// selection stage\n')
f.write('genvar i;\n')
f.write('generate\n')
f.write(f'  for (i = 0; i < {outputsNum}; i = i + 1) begin : SEL_GEN\n')
f.write('    always_comb begin\n')
f.write('      case(i)\n')
for i in range(inputsNum):
    f.write(f'        rank[{i}]: {outputVar}[i] = {inputVar}[{i}];\n')
f.write(f'        default: {outputVar}[i] = 0;\n')
f.write('      endcase\n')
f.write('    end\n')
f.write('  end\n')
f.write('endgenerate\n')

f.close()
