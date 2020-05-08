# This is an autogenerated file for dynamic methods in Loan
# Please rerun bundle exec rake rails_rbi:models[Loan] to regenerate.

# typed: strong
module Loan::ActiveRelation_WhereNot
  sig { params(opts: T.untyped, rest: T.untyped).returns(T.self_type) }
  def not(opts, *rest); end
end

module Loan::GeneratedAttributeMethods
  sig { returns(T.nilable(Integer)) }
  def copy_id; end

  sig { params(value: T.nilable(T.any(Numeric, ActiveSupport::Duration))).void }
  def copy_id=(value); end

  sig { returns(T::Boolean) }
  def copy_id?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def created_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def created_at=(value); end

  sig { returns(T::Boolean) }
  def created_at?; end

  sig { returns(Integer) }
  def id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def id=(value); end

  sig { returns(T::Boolean) }
  def id?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def loan_date; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def loan_date=(value); end

  sig { returns(T::Boolean) }
  def loan_date?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def return_date; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def return_date=(value); end

  sig { returns(T::Boolean) }
  def return_date?; end

  sig { returns(T.nilable(Integer)) }
  def returned_by_id; end

  sig { params(value: T.nilable(T.any(Numeric, ActiveSupport::Duration))).void }
  def returned_by_id=(value); end

  sig { returns(T::Boolean) }
  def returned_by_id?; end

  sig { returns(T.nilable(Integer)) }
  def returned_to_shelf_id; end

  sig { params(value: T.nilable(T.any(Numeric, ActiveSupport::Duration))).void }
  def returned_to_shelf_id=(value); end

  sig { returns(T::Boolean) }
  def returned_to_shelf_id?; end

  sig { returns(T.nilable(String)) }
  def state; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def state=(value); end

  sig { returns(T::Boolean) }
  def state?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def updated_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def updated_at=(value); end

  sig { returns(T::Boolean) }
  def updated_at?; end

  sig { returns(T.nilable(Integer)) }
  def user_id; end

  sig { params(value: T.nilable(T.any(Numeric, ActiveSupport::Duration))).void }
  def user_id=(value); end

  sig { returns(T::Boolean) }
  def user_id?; end
end

module Loan::GeneratedAssociationMethods
  sig { returns(T.nilable(::Book)) }
  def book; end

  sig { params(value: T.nilable(::Book)).void }
  def book=(value); end

  sig { returns(::Copy) }
  def copy; end

  sig { params(value: ::Copy).void }
  def copy=(value); end

  sig { returns(T.nilable(::User)) }
  def returned_by; end

  sig { params(value: T.nilable(::User)).void }
  def returned_by=(value); end

  sig { returns(T.nilable(::Shelf)) }
  def returned_to_shelf; end

  sig { params(value: T.nilable(::Shelf)).void }
  def returned_to_shelf=(value); end

  sig { returns(::User) }
  def user; end

  sig { params(value: ::User).void }
  def user=(value); end
end

module Loan::CustomFinderMethods
  sig { params(limit: Integer).returns(T::Array[Loan]) }
  def first_n(limit); end

  sig { params(limit: Integer).returns(T::Array[Loan]) }
  def last_n(limit); end

  sig { params(args: T::Array[T.any(Integer, String)]).returns(T::Array[Loan]) }
  def find_n(*args); end

  sig { params(id: Integer).returns(T.nilable(Loan)) }
  def find_by_id(id); end

  sig { params(id: Integer).returns(Loan) }
  def find_by_id!(id); end
end

class Loan < ApplicationRecord
  include Loan::GeneratedAttributeMethods
  include Loan::GeneratedAssociationMethods
  extend Loan::CustomFinderMethods
  extend Loan::QueryMethodsReturningRelation
  RelationType = T.type_alias { T.any(Loan::ActiveRecord_Relation, Loan::ActiveRecord_Associations_CollectionProxy, Loan::ActiveRecord_AssociationRelation) }
end

module Loan::QueryMethodsReturningRelation
  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def history(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def on_loan(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def recently_loaned(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def returned(*args); end

  sig { returns(Loan::ActiveRecord_Relation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(Loan::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def reselect(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def extract_associated(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def optimizer_hints(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def except(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_Relation) }
  def only(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Loan::ActiveRecord_Relation) }
  def extending(*args, &block); end
end

module Loan::QueryMethodsReturningAssociationRelation
  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def history(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def on_loan(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def recently_loaned(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def returned(*args); end

  sig { returns(Loan::ActiveRecord_AssociationRelation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(Loan::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def reselect(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def extract_associated(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def optimizer_hints(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def except(*args); end

  sig { params(args: T.untyped).returns(Loan::ActiveRecord_AssociationRelation) }
  def only(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Loan::ActiveRecord_AssociationRelation) }
  def extending(*args, &block); end
end

class Loan::ActiveRecord_Relation < ActiveRecord::Relation
  include Loan::ActiveRelation_WhereNot
  include Loan::CustomFinderMethods
  include Loan::QueryMethodsReturningRelation
  Elem = type_member(fixed: Loan)
end

class Loan::ActiveRecord_AssociationRelation < ActiveRecord::AssociationRelation
  include Loan::ActiveRelation_WhereNot
  include Loan::CustomFinderMethods
  include Loan::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: Loan)
end

class Loan::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include Loan::CustomFinderMethods
  include Loan::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: Loan)

  sig { params(records: T.any(Loan, T::Array[Loan])).returns(T.self_type) }
  def <<(*records); end

  sig { params(records: T.any(Loan, T::Array[Loan])).returns(T.self_type) }
  def append(*records); end

  sig { params(records: T.any(Loan, T::Array[Loan])).returns(T.self_type) }
  def push(*records); end

  sig { params(records: T.any(Loan, T::Array[Loan])).returns(T.self_type) }
  def concat(*records); end
end