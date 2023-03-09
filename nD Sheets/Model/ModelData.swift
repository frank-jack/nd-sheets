//
//  ModelData.swift
//  nD Sheets
//
//  Created by Jack Frank on 1/9/23.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var sheetList = [Sheet]()
    var sheetId = Int()
    var sheet = [Cell]()
    @Published var size = [35, 5, 5]
    @Published var labels = [[Int]]()
    @Published var n = Int()
    @Published var idCount = 0
    @Published var dim1 = 0
    @Published var dim2 = 1
    @Published var dimsHidden = [Int]()
    @Published var dimsHiddenValues = [Int]()
    @Published var input = [[Int]]()
    @Published var idHighlighted = -1
    var sheetTitle = "Title"
    /*init() {
        initCall()
    }*/
    func initCall() {
        n = size.count
        idCount = 0
        let tempSheet = sheet
        sheet = [Cell]()
        setUp(dim: n, listOfIndex: [], tempSheet: tempSheet)
        //print(sheet)
        setLabels()
        if n > 2 {
            setDimsHidden()
        }
        input = [[Int]]()
    }
    func setUp(dim: Int, listOfIndex: [Int], tempSheet: [Cell]) {
        var tempList = listOfIndex
        if dim > 0 {
            for i in 1...size[dim-1] {
                tempList.append(i)
                setUp(dim: dim-1, listOfIndex: tempList, tempSheet: tempSheet)
                tempList = listOfIndex
            }
        }
        else {
            if tempSheet.count > idCount {
                sheet.append(Cell(id: idCount, text: tempSheet[idCount].text, pos: listOfIndex.reversed()))
            } else {
                sheet.append(Cell(id: idCount, text: "", pos: listOfIndex.reversed()))
            }
            idCount += 1
        }
    }
    func setDimsHidden() {
        dimsHidden = [Int]()
        for i in 0...n-1 {
            if i != dim1 && i != dim2 {
                dimsHidden.append(i)
            }
        }
        dimsHiddenValues = [Int]()
        for _ in 0...n-3 {
            dimsHiddenValues.append(1)
        }
    }
    func setLabels() {
        labels = [[Int]]()
        for i in 0...n-1 {
            labels.append([Int]())
            for j in 1...size[i] {
                labels[i].append(j)
            }
        }
    }
    func getCell(pos: [Int]) -> Cell {
        let possibles = sheet
        var cell = Cell(id: -1, text: "", pos: [-1])
        for i in 0...possibles.count-1 {
            var check = true
            for j in 0...n-1 {
                if possibles[i].pos[j] != pos[j] {
                    check = false
                }
            }
            if check {
                cell = possibles[i]
            }
        }
        return cell
    }
    func getPos(row: Int, col: Int) -> [Int] {
        var pos = [Int]()
        for i in 0...n-1 {
            if i == dim1 {
                pos.append(row)
            } else if i == dim2 {
                pos.append(col)
            } else {
                for j in 0...dimsHidden.count-1 {
                    if i == dimsHidden[j] {
                        pos.append(dimsHiddenValues[j])
                    }
                }
            }
        }
        return pos
    }
    func addDim() {
        size.append(5)
        initCall()
    }
    func addLine(spot: Int, dim1: Int, dim2: Int) {
        //print("Spot:"+String(spot))
        //print("dim1:"+String(dim1))
        //print("dim2:"+String(dim2))
        //Adjust size
        size[dim1]+=1
        n = size.count
        //print("New size")
        //print(size)
        //Find Indicies (pos) of new cells
        var listOfIndex = [[Int]]()
        for i in sheet {
            if i.pos[dim1] == spot {
                listOfIndex.append(i.pos)
            }
        }
        if spot > size[dim1]-1 {
            for i in sheet {
                if i.pos[dim1] == spot-1 {
                    var tempPos = [Int]()
                    for j in 0...i.pos.count-1 {
                        if j == dim1 {
                            tempPos.append(i.pos[j]+1)
                        } else {
                            tempPos.append(i.pos[j])
                        }
                    }
                    listOfIndex.append(tempPos)
                }
            }
        }
        //print("Pos of New Cells")
        //print(listOfIndex)
        //Adjust all cells after new line
        var tempSheet = sheet
        for i in 0...sheet.count-1 {
            for j in 0...sheet[i].pos.count-1 {
                if j == dim1 {
                    if sheet[i].pos[j] >= spot {
                        tempSheet[i].pos[j]+=1
                    }
                }
            }
        }
        sheet = tempSheet
        //print("Sheet adjusted")
        //print(sheet)
        //Add new line with bogus IDs
        for i in 0...listOfIndex.count-1 {
            sheet.append(Cell(id: -1*i-1, text: "", pos: listOfIndex[i]))
        }
        //print("Sheet with bad ids made")
        //print(sheet)
        //Fix ID
        tempSheet = sheet
        sheet = [Cell]()
        inputFunc(dim: n, listOfIndex: [])
        //print("Input")
        //print(input)
        for i in 0...input.count-1 {
            sheet.append(Cell(id: i, text: "", pos: input[i]))
        }
        for i in 0...sheet.count-1 {
            for j in tempSheet {
                if sheet[i].pos == j.pos {
                    sheet[i].text = j.text
                }
            }
        }
        //print("Final")
        //print(sheet)
        initCall()
    }
    func inputFunc(dim: Int, listOfIndex: [Int]) {
        //Organizing pos
        var tempList = listOfIndex
        if dim > 0 {
            for i in 1...size[dim-1] {
                tempList.append(i)
                inputFunc(dim: dim-1, listOfIndex: tempList)
                tempList = listOfIndex
            }
        }
        else {
            input.append(listOfIndex.reversed())
        }
    }
    func deleteLine(spot: Int, dim1: Int, dim2: Int) {
        size[dim1]-=1
        n = size.count
        var badIds = [Int]()
        for i in 0...sheet.count-1 {
            if sheet[i].pos[dim1] == spot {
                badIds.append(i)
            }
        }
        //Adjust all cells after new line
        var tempSheet = sheet
        for i in 0...sheet.count-1 {
            for j in 0...sheet[i].pos.count-1 {
                if j == dim1 {
                    if sheet[i].pos[j] >= spot {
                        tempSheet[i].pos[j]-=1
                    }
                }
            }
        }
        sheet = tempSheet
        //print("Sheet adjusted")
        //print(sheet)
        //Remove Bads
        for i in 0...sheet.count-1 {
            if badIds.contains((sheet.count-1)-i) {
                sheet.remove(at: (sheet.count-1)-i)
            }
        }
        //Fix ID
        tempSheet = sheet
        sheet = [Cell]()
        inputFunc(dim: n, listOfIndex: [])
        //print("Input")
        //print(input)
        for i in 0...input.count-1 {
            sheet.append(Cell(id: i, text: "", pos: input[i]))
        }
        for i in 0...sheet.count-1 {
            for j in tempSheet {
                if sheet[i].pos == j.pos {
                    sheet[i].text = j.text
                }
            }
        }
        //print("Final")
        //print(sheet)
        initCall()
    }
    func removeDim(dim: Int) {
        //print("Dim: "+String(dim))
        size.remove(at: dim)
        n = size.count
        var badIds = [Int]()
        for i in sheet {
            if i.pos[dim] != 1 {
                badIds.append(i.id)
            }
        }
        //print("bads")
        //print(badIds)
        //Remove Bads
        for i in badIds.reversed() {
            sheet.remove(at: i)
        }
        //print("Sheet with them removed")
        //print(sheet)
        //Fix ID prologue
        for i in 0...sheet.count-1 {
            sheet[i].pos.remove(at: dim)
        }
        //Fix ID
        let tempSheet = sheet
        sheet = [Cell]()
        inputFunc(dim: n, listOfIndex: [])
        //print("Input")
        //print(input)
        for i in 0...input.count-1 {
            sheet.append(Cell(id: i, text: "", pos: input[i]))
        }
        for i in 0...sheet.count-1 {
            for j in tempSheet {
                if sheet[i].pos == j.pos {
                    sheet[i].text = j.text
                }
            }
        }
        //print("Final")
        //print(sheet)
        dimsHidden = [Int]()
        dimsHiddenValues = [Int]()
        initCall()
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("list.data")
    }
    static func load(completion: @escaping (Result<[Sheet], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let sheetList = try JSONDecoder().decode([Sheet].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(sheetList))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    static func save(sheetList: [Sheet], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(sheetList)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(sheetList.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
