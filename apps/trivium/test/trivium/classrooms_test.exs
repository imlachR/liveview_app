defmodule Trivium.ClassroomsTest do
  use Trivium.DataCase

  alias Trivium.Classrooms

  describe "progresses" do
    alias Trivium.Classrooms.Progress

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def progress_fixture(attrs \\ %{}) do
      {:ok, progress} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classrooms.create_progress()

      progress
    end

    test "list_progresses/0 returns all progresses" do
      progress = progress_fixture()
      assert Classrooms.list_progresses() == [progress]
    end

    test "get_progress!/1 returns the progress with given id" do
      progress = progress_fixture()
      assert Classrooms.get_progress!(progress.id) == progress
    end

    test "create_progress/1 with valid data creates a progress" do
      assert {:ok, %Progress{} = progress} = Classrooms.create_progress(@valid_attrs)
      assert progress.status == "some status"
    end

    test "create_progress/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classrooms.create_progress(@invalid_attrs)
    end

    test "update_progress/2 with valid data updates the progress" do
      progress = progress_fixture()
      assert {:ok, %Progress{} = progress} = Classrooms.update_progress(progress, @update_attrs)
      assert progress.status == "some updated status"
    end

    test "update_progress/2 with invalid data returns error changeset" do
      progress = progress_fixture()
      assert {:error, %Ecto.Changeset{}} = Classrooms.update_progress(progress, @invalid_attrs)
      assert progress == Classrooms.get_progress!(progress.id)
    end

    test "delete_progress/1 deletes the progress" do
      progress = progress_fixture()
      assert {:ok, %Progress{}} = Classrooms.delete_progress(progress)
      assert_raise Ecto.NoResultsError, fn -> Classrooms.get_progress!(progress.id) end
    end

    test "change_progress/1 returns a progress changeset" do
      progress = progress_fixture()
      assert %Ecto.Changeset{} = Classrooms.change_progress(progress)
    end
  end
end
