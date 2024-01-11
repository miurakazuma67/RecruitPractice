//
//  ContentView.swift
//  RecruitPractice
//
//  Created by 三浦　一真 on 2024/01/02.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var contents: [Content]? = nil // サイドバーに表示されるデータ
    @State private var content: Content? = nil // 右側に表示されるデータ
    @State private var contentTitle: String? = nil // タイトル
    @State private var contentBody: String? = nil // ボディデータ
    @State private var listEdited: Bool = false // 一覧が編集状態かどうか
    @State private var titleEdited: Bool = false // titleが編集状態かどうか
    @State private var bodyEdited: Bool = false // bodyが編集状態かどうか
    @State private var newPageTapped: Bool = false // +ボタンが編集状態かどうか

    var body: some View {
            HStack() {
                VStack {
                    // ロゴ＋アイコン
                    HStack {
                        ScalableImageView(UIImage(named: "logo")!)
                            .frame(width: 32, height: 32)
                        Text("ServiceName")
                            .foregroundColor(Color.colorTextRegular)
                            .font(.notoBold(size: 20))
                    }

                    // サイドバー
                    ScrollView{
                        if let unwrappedContents = contents {
                            ForEach(unwrappedContents, id: \.id) { content in
                                HStack{
                                    Text(content.title)
                                        .onTapGesture {
                                            // セルがタップされた時の処理をここに記述
                                            updateTitleAndBody(content: content)
                                            Task {
                                                await updateData(id: content.id)
                                            }
                                        }
//                                    if listEdited {
                                        ColorImageButton(
                                            imageName: "delete",
                                            foregroundColor: Color.white,
                                            backgroundColor: Color.clear,
                                            width: 40,
                                            height: 30,
                                            buttonText: "",
                                            action: {
                                                Task {
                                                    await deleteData(id: content.id)
                                                }
                                            },
                                            borderContain: false
                                        )
//                                    }
                                }
                            }
                        }
                    }
                    // EditButton ----------------------------------------------------
                    if listEdited {
                        HStack {
                            ColorImageButton(
                                imageName: "+",
                                foregroundColor: Color.primaryBlue,
                                backgroundColor: Color.white,
                                width: 90,
                                height: 40,
                                buttonText: "New Page",
                                action: {}, //削除処理を実行
                                borderContain: true
                            )
                            Spacer()
                            ColorImageButton(
                                imageName: "done",
                                foregroundColor: Color.white,
                                backgroundColor: Color.primaryBlue,
                                width: 90,
                                height: 40,
                                buttonText: "Done",
                                action: {listEdited = false},
                                borderContain: false
                            )
                        }
                    }
                    else
                    {
                        ColorImageButton(
                            imageName: "edit",
                            foregroundColor: Color.white,
                            backgroundColor: Color.primaryBlue,
                            width: 90,
                            height: 40,
                            buttonText: "Edit",
                            action: { listEdited = true }, 
                            borderContain: false
                        )
                    }
                    // EditButton ------------------------------------------------
                }
                // 右側の編集画面
                NavigationView {
                    Form {
                        Section {
                            HStack {
                                Text(contentBody ?? "内容")
                                    .font(.notoRegular(size: 10))
                                .padding(5)
                                Spacer()
                                // EditButton -----------------------
                                if bodyEdited {
                                    HStack {
                                        ColorImageButton(
                                            imageName: "cancel",
                                            foregroundColor: Color.white,
                                            backgroundColor: Color.textLight,
                                            width: 40,
                                            height: 40,
                                            buttonText: "Cancel",
                                            action: {bodyEdited = false},
                                            borderContain: false
                                        )
                                        Spacer()
                                        ColorImageButton(
                                            imageName: "save",
                                            foregroundColor: Color.white,
                                            backgroundColor: Color.primaryBlue,
                                            width: 40,
                                            height: 40,
                                            buttonText: "Save",
                                            action: {bodyEdited = false},
                                            borderContain: false
                                        )
                                    }
                                }
                                else
                                {
                                    ColorImageButton(
                                        imageName: "edit",
                                        foregroundColor: Color.white,
                                        backgroundColor: Color.primaryBlue,
                                        width: 90,
                                        height: 40,
                                        buttonText: "Edit",
                                        action: { bodyEdited = true },
                                        borderContain: false
                                    )
                                }
                                // EditButton ------------------------
                            }
                        }
                    }
                    .navigationTitle(contentTitle ?? "タイトル")
                    .font(.notoBold(size: 12))
                }
            }
            .onAppear(perform: {
                Task {
                    await fetchDataList()
                }
            })
        }

    /// APIからデータ一覧を非同期で取得するメソッド
    func fetchDataList() async {
        do {
            // APIのエンドポイントを指定
            let url = URL(string: "http://localhost:3000/content")!

            // URLRequestの作成
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            // APIリクエストの実行
            let (data, _) = try await URLSession.shared.data(from: url)

            // 取得したデータをデコードして、@State変数に格納
            let decodedData = try JSONDecoder().decode([Content].self, from: data)
            self.contents = decodedData
        } catch {
            // エラー処理
            print("Error fetching data: \(error)")
        }
    }

    // APIからデータ一覧を非同期で更新する関数
    func updateData(id: Int) async {
        do {
            let url = URL(string: "http://localhost:3000/content/\(id)")!

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.allHTTPHeaderFields = ["title": "更新した", "body": "更新した"]

            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse {
                // レスポンスが成功の場合
                if httpResponse.statusCode == 200 {
                    let decodedData2 = try JSONDecoder().decode(Content.self, from: data)
//                    if id = decodedData2.id {
//                        contents
//                    }
                } else {
                    // レスポンスが成功でない場合
                    print("HTTP Error: \(httpResponse.statusCode)")
                }
            }
            // レスポンスデータの内容を表示
            if let responseDataString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseDataString)")
            }
        } catch {
            print("Error updating data: \(error)")
        }
    }

    /// データ削除 削除ボタン押下時
    func deleteData(id: Int) async {
        do {
            // APIのエンドポイントを指定
            let url = URL(string: "http://localhost:3000/content/\(id)")!

            // URLRequestの作成
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"

            // APIリクエストの実行
            let (data, _) = try await URLSession.shared.data(from: url)

            // 削除が成功したら、リロード
            await fetchDataList()
        } catch {
            // エラー処理
            print("Error fetching data: \(error)")
        }
    }

    ///右側に表示するタイトル, 内容を更新
    func updateTitleAndBody(content: Content) {
        contentTitle = content.title
        contentBody = content.body
    }
}

#Preview {
    ContentView()
}
