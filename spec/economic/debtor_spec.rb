require './spec/spec_helper'

describe Economic::Debtor do
  let(:session) { make_session }
  subject { Economic::Debtor.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::Debtor.ancestors).to include(Economic::Entity)
  end

  describe "class methods" do
    subject { Economic::Debtor }

    describe ".proxy" do
      it "should return DebtorProxy" do
        expect(subject.proxy).to eq(Economic::DebtorProxy)
      end
    end

    describe ".key" do
      it "should == :debtor" do
        expect(Economic::Debtor.key).to eq(:debtor)
      end
    end
  end

  context "when saving" do
    context "when debtor is new" do
      subject { Economic::Debtor.new(:session => session) }

      context "when debtor_group_handle is nil" do
        before :each do
          subject.debtor_group_handle = nil
        end

        it "should send request and let e-conomic return an error" do
          expect(session).to receive(:request)
          subject.save
        end
      end
    end
  end

  describe ".current_invoices" do
    it "returns an CurrentInvoiceProxy" do
      expect(subject.current_invoices).to be_instance_of(Economic::CurrentInvoiceProxy)
    end

    it "memoizes the proxy" do
      expect(subject.current_invoices).to equal(subject.current_invoices)
    end

    it "should store the session" do
      expect(subject.session).to_not be_nil
      expect(subject.current_invoices.session).to eq(subject.session)
    end
  end

  describe ".contacts" do
    it "returns a DebtorContactProxy" do
      expect(subject.contacts).to be_instance_of(Economic::DebtorContactProxy)
    end

    it "memoizes the proxy" do
      expect(subject.contacts).to equal(subject.contacts)
    end

    it "should store the session" do
      expect(subject.session).to_not be_nil
      expect(subject.contacts.session).to eq(subject.session)
    end
  end

  describe ".proxy" do
    it "should return a DebtorProxy" do
      expect(subject.proxy).to be_instance_of(Economic::DebtorProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end

  describe "equality" do
    context "when other handle is equal" do
      context "when other is a different class" do
        let(:other) { Economic::Invoice.new(:session => session, :handle => subject.handle) }

        it "should return false" do
          expect(subject).not_to eq(other)
        end
      end
    end
  end

end
