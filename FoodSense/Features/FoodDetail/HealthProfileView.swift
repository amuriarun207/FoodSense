import SwiftUI

struct HealthProfileView: View {
    let profile: HealthProfile?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health profile")
                .font(.title3.weight(.semibold))

            Text("This is general food information, not medical advice.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            if let profile, profile.hasContent {
                if let summary = profile.summary, !summary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(summary)
                        .font(.body)
                }

                if let typical = profile.typicalServingNote, !typical.isEmpty {
                    LabeledContent("Typical serving", value: typical)
                }

                if let evidence = profile.evidenceLevel {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Evidence: \(evidence.displayName)")
                            .font(.subheadline.weight(.medium))
                        Text(evidence.explanatoryText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                factSection(title: "Benefits", facts: profile.benefits)
                factSection(title: "Considerations", facts: profile.considerations)
                factSection(title: "Excess intake", facts: profile.excessIntake)
            } else {
                Text("Health information is not available for this food yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private func factSection(title: String, facts: [HealthFact]) -> some View {
        if !facts.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                ForEach(facts) { fact in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(fact.title)
                            .font(.subheadline.weight(.semibold))
                        Text(fact.description)
                            .font(.subheadline)
                        Text("Evidence: \(fact.evidenceLevel.displayName)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }
}
