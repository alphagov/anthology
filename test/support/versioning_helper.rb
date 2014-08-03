module VersioningHelper
  # https://github.com/airblade/paper_trail#globally
  # and https://github.com/airblade/paper_trail/issues/341
  def with_versioning
    was_enabled = PaperTrail.enabled?
    controller_was_enabled = PaperTrail.enabled_for_controller?

    PaperTrail.enabled = true
    PaperTrail.enabled_for_controller = true

    begin
      yield
    ensure
      PaperTrail.enabled = was_enabled
      PaperTrail.enabled_for_controller = PaperTrail.enabled_for_controller?
    end
  end
end
