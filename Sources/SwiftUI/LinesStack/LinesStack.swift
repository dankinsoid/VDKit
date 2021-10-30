//
//  TagsView.swift
//  MonthCalendar
//
//  Created by Данил Войдилов on 01.10.2021.
//

import SwiftUI
import BindGeometry

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct LinesStack<Data: Collection, ID: Hashable, Content: View>: View {
  let data: Data
  let spacing: CGFloat
  let lineSpacing: CGFloat
  let alignment: HorizontalAlignment
  let content: (Data.Element) -> Content
  let getId: (Data.Element) -> ID
  @State private var availableSize: CGSize = .zero
  
  public init(_ data: Data, id: @escaping (Data.Element) -> ID, spacing: CGFloat = 0, lineSpacing: CGFloat = 0, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
    self.data = data
    self.spacing = spacing
    self.lineSpacing = lineSpacing
    self.alignment = alignment
    self.content = content
    self.getId = id
  }
  
  public init(_ data: Data, id: KeyPath<Data.Element, ID>, spacing: CGFloat = 0, lineSpacing: CGFloat = 0, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
    self = .init(data, id: { $0[keyPath: id] }, spacing: spacing, lineSpacing: lineSpacing, alignment: alignment, content: content)
  }
  
  public var body: some View {
    ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
      Color.clear
        .frame(height: 1)
        .bindSize(to: $availableSize)
      
      _TagsView(
        availableWidth: availableSize.width,
        data: data,
        spacing: spacing,
        lineSpacing: lineSpacing,
        alignment: alignment,
        content: content,
        getId: getId
      )
    }
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension LinesStack where Data.Element: Identifiable, ID == Data.Element.ID {
  
  public init(_ data: Data, spacing: CGFloat = 0, lineSpacing: CGFloat = 0, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
    self = .init(data, id: { $0.id }, spacing: spacing, lineSpacing: lineSpacing, alignment: alignment, content: content)
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct _TagsView<Data: Collection, ID: Hashable, Content: View>: View {
  let availableWidth: CGFloat
  let data: Data
  let spacing: CGFloat
  let lineSpacing: CGFloat
  let alignment: HorizontalAlignment
  let content: (Data.Element) -> Content
  let getId: (Data.Element) -> ID
  @State var elementsSize: [ID: CGSize] = [:]
  
  var body: some View {
    VStack(alignment: alignment, spacing: lineSpacing) {
      ForEach(Array(computeRows().enumerated()), id: \.offset) { rowElements in
        row(rowElements: rowElements.element)
      }
    }
  }
  
  private func row(rowElements: [Data.Element]) -> some View {
    HStack(spacing: spacing) {
      ForEach(rowElements.map { Element(getId: getId, element: $0) }) { element in
        content(element.element)
          .fixedSize()
					.bindSize(to: .init {
						elementsSize[element.id, default: .zero]
					} set: {
						elementsSize[element.id, default: .zero] = $0
					})
      }
    }
  }
  
  private struct Element: Identifiable {
    var id: ID { getId(element) }
    let getId: (Data.Element) -> ID
    let element: Data.Element
  }
  
  func computeRows() -> [[Data.Element]] {
    var rows: [[Data.Element]] = [[]]
    var currentRow = 0
    var remainingWidth = availableWidth
    
    for element in data {
      let elementSize = elementsSize[getId(element), default: CGSize(width: availableWidth, height: 1)]
      
      if remainingWidth - (elementSize.width + spacing) >= 0 {
        rows[currentRow].append(element)
      } else {
        currentRow = currentRow + 1
        rows.append([element])
        remainingWidth = availableWidth
      }
      
      remainingWidth = remainingWidth - (elementSize.width + spacing)
    }
    
    return rows
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct TagsView_Previews: PreviewProvider {
  static var previews: some View {
    LinesStack(
      [
        "Here’s", "to", "the", "crazy", "ones", "the", "misfits", "the", "rebels", "the", "troublemakers", "the"
      ],
      id: \.self,
      spacing: 12,
      lineSpacing: 10
    ) { item in
      Text(verbatim: item)
        .padding(8)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
        )
    }
    .padding(.horizontal, 12)
  }
}
