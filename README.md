# bachelor-tools

## Installation
```
npm install
```

## Structure
`scripts/`: All scripts used to generate the results of the experiments.  
`tools/`: Tools used by one or more scripts.  
`analysis/`: Analysis files for Jalangi.  
`babel/`: JavaScript files in `babel/src/` can be converted to ES5-compatible code with `npm run build`. Results are stored in `babel/lib/`.  

## Scripts

All scripts need the following initial structure:  
```
results/
├─ package_files/
├─ modules/
└─ output/
```
After using the scripts the structure will be like this:
```
results/
├─ package_files/
│  ├─ module1/
│  │  └─ package.json
│  ├─ module2/
│  │  └─ package.json
│  └─ ...
├─ modules/
│  ├─ module1/
│  │  ├─ src/
│  │  ├─ lib/
│  │  ├─ src_instrumented/
│  │  └─ lib_instrumented/
│  ├─ module2/
│  │  └─ ...
│  └─ ...
├─ output/
│  ├─ module1/
│  │  ├─ normal
│  │  │  ├─ output.json
│  │  │  ├─ output_fixed.json
│  │  │  └─ index.d.ts
│  │  └─ cleaned/
│  │     ├─ output.json
│  │     ├─ output_fixed.json
│  │     └─ index.d.ts
│  ├─ module2/
│  │  └─ ...
│  └─ ...
├─ compare/
│  ├─ differences/
│  │  ├─ module1.json
│  │  ├─ module2.json
│  │  └─ ...
│  └─ comparison.csv
├─ log_file1.log
├─ log_file2.log
└─ log_file3.log
```

### 1_extract-modules

#### `extractDefinitelyTypedModules.sh`

```
./scripts/1_extract-modules/extractDefinitelyTypedModules.sh <DefinitelyTyped path> <output path>
```

#### `extractTop1000Modules.sh`

```
./scripts/1_extract-modules/extractTop1000Modules.sh <output path>
```

### 2_get-repositories

#### `getRepositories.sh`

```
./scripts/2_get-repositories/getRepositories.sh <modules csv> <output path>
```

### 3_extract-test-scripts

#### `retrievePackageFiles.sh`

```
./scripts/3_extract-test-scripts/retrievePackageFiles.sh <modules with repo csv> <path to results/package_files/>
```

#### `extractTestScripts.sh`

```
./scripts/3_extract-test-scripts/extractTestScripts.sh <path to results/package_files/> <output path>
```

### 4_analyse-test-scripts

#### `analyseTestScripts.sh`

```
./scripts/4_analyse-test-scripts/analyseTestScripts.sh <test scripts DefinitelyTyped> <test scripts Top1000> <output path>
```

### 5_clone-repositories

#### `cloneRepos.sh`

```
./scripts/5_clone-repositories/cloneRepos.sh <modules with repo csv> <path to results/modules/>
```

### 6_instrumentation

#### `instrumentAllNoBabel.sh`

```
./scripts/6_instrumentation/instrumentAllNoBabel.sh <path to results/modules/>
```

#### `instrumentAllBabel.sh`

```
./scripts/6_instrumentation/instrumentAllBabel.sh <path to results/modules/>
```

#### `generateJalangi.sh`

```
./scripts/6_instrumentation/generateJalangi.sh <path to results>
```

#### `injectAll.sh`

```
./scripts/6_instrumentation/injectAll.sh <path to results/modules/> <modules with test script csv>
```

### 7_installation

#### `installAll.sh` 

```
./scripts/7_installation/installAll.sh <path to results/modules/> <modules with test script csv>
```

### 8_test+generate-rund-time-info

#### `testAll.sh`

```
./scripts/8_test+generate-rund-time-info/testAll.sh <path to results/modules/> <modules to test csv>
```

#### `cleanupTestScriptAll.sh`

```
./scripts/8_test+generate-rund-time-info/cleanupTestScriptAll.sh <path to results/modules/> <modules to test csv>
```

#### `testAllInstrumentedNoAnalysis.sh`

```
./scripts/8_test+generate-rund-time-info/testAllInstrumentedNoAnalysis.sh <path to results/modules/> <modules to test csv>
```

#### `testAllInstrumentedAnalysis.sh`

```
./scripts/8_test+generate-rund-time-info/testAllInstrumentedAnalysis.sh <path to results/modules/> <modules to test csv>
```

#### `testAllCleanInstrumentedNoAnalysis.sh`

```
./scripts/8_test+generate-rund-time-info/testAllCleanInstrumentedNoAnalysis.sh <path to results/modules/> <modules to test csv>
```

#### `testAllCleanInstrumentedAnalysis.sh`

```
./scripts/8_test+generate-rund-time-info/testAllCleanInstrumentedAnalysis.sh <path to results/modules/> <modules to test csv>
```

### 9_analyse-run-time-info

#### `validateAllAnalysisFiles.sh`

```
./scripts/9_analyse-run-time-info/validateAllAnalysisFiles.sh <path to results/output/>
```

#### `fixAllAnalysisFiles.sh`

```
./scripts/9_analyse-run-time-info/fixAllAnalysisFiles.sh <path to results/output/>
```

### 10_generate-declaration-file

#### `generateDeclarationFilesAll.sh`

```
./scripts/10_generate-declaration-file/generateDeclarationFilesAll.sh <path to results/output/>
```

### 11_analyse-declaration-file

#### `generateDeclarationFilesAll.sh`

```
./scripts/10_generate-declaration-file/generateDeclarationFilesAll.sh <path to results/output/>
```

### 12_compare

#### `compareDeclarationFilesAll.sh`

```
./scripts/10_generate-declaration-file/compareDeclarationFilesAll.sh <path to results/> <path to DefinitelyTyped>
```

### 13_compare-methods

#### `compareDeclarationFileMethods.sh`

```
./scripts/10_generate-declaration-file/compareDeclarationFilesAll.sh <readme comparison csv> <test comparison csv> <output path>
```