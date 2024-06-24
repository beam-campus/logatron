defmodule Flags do
  import Bitwise

  def set(target, flag), do: bor(target, flag)
  def has?(target, flag), do: band(target, flag) == flag
  def unset(target, flag), do: bxor(target,flag)
  def has_not?(target, flag), do: band(target, flag) != flag

  def set_flags(target, [] = flags), do: Enum.reduce(flags, target, &set/2)
  def unset_flags(target, [] = flags), do: Enum.reduce(flags, target, &unset/2)




end
