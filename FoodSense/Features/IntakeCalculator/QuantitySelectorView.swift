import SwiftUI

struct QuantitySelectorView: View {
    let presets: [QuantityPreset]
    @Binding var selectedPreset: QuantityPreset
    @Binding var customText: String
    let onSelect: (QuantityPreset) -> Void
    let onCustomCommit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How much are you eating?")
                .font(.title3.weight(.semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(presets) { preset in
                        Button {
                            onSelect(preset)
                        } label: {
                            Text(preset.title)
                                .font(.subheadline.weight(.medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    selectedPreset == preset ? Color.accentColor : Color(.secondarySystemBackground),
                                    in: Capsule()
                                )
                                .foregroundStyle(selectedPreset == preset ? Color.white : Color.primary)
                        }
                        .accessibilityLabel(preset.title)
                        .accessibilityAddTraits(selectedPreset == preset ? .isSelected : [])
                    }
                }
            }

            if selectedPreset == .custom {
                HStack {
                    TextField("Grams", text: $customText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit(onCustomCommit)
                    Text("g")
                        .foregroundStyle(.secondary)
                    Button("Apply", action: onCustomCommit)
                        .buttonStyle(.bordered)
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Custom quantity in grams")
            }
        }
    }
}
