defmodule Trivium.MultimediaTest do
  use Trivium.DataCase

  alias Trivium.Multimedia

  describe "frames" do
    alias Trivium.Multimedia.Frame

    @valid_attrs %{code: "some code"}
    @update_attrs %{code: "some updated code"}
    @invalid_attrs %{code: nil}

    def frame_fixture(attrs \\ %{}) do
      {:ok, frame} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Multimedia.create_frame()

      frame
    end

    test "list_frames/0 returns all frames" do
      frame = frame_fixture()
      assert Multimedia.list_frames() == [frame]
    end

    test "get_frame!/1 returns the frame with given id" do
      frame = frame_fixture()
      assert Multimedia.get_frame!(frame.id) == frame
    end

    test "create_frame/1 with valid data creates a frame" do
      assert {:ok, %Frame{} = frame} = Multimedia.create_frame(@valid_attrs)
      assert frame.code == "some code"
    end

    test "create_frame/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_frame(@invalid_attrs)
    end

    test "update_frame/2 with valid data updates the frame" do
      frame = frame_fixture()
      assert {:ok, %Frame{} = frame} = Multimedia.update_frame(frame, @update_attrs)
      assert frame.code == "some updated code"
    end

    test "update_frame/2 with invalid data returns error changeset" do
      frame = frame_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_frame(frame, @invalid_attrs)
      assert frame == Multimedia.get_frame!(frame.id)
    end

    test "delete_frame/1 deletes the frame" do
      frame = frame_fixture()
      assert {:ok, %Frame{}} = Multimedia.delete_frame(frame)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_frame!(frame.id) end
    end

    test "change_frame/1 returns a frame changeset" do
      frame = frame_fixture()
      assert %Ecto.Changeset{} = Multimedia.change_frame(frame)
    end
  end

  describe "image_urls" do
    alias Trivium.Multimedia.ImageUrl

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def image_url_fixture(attrs \\ %{}) do
      {:ok, image_url} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Multimedia.create_image_url()

      image_url
    end

    test "list_image_urls/0 returns all image_urls" do
      image_url = image_url_fixture()
      assert Multimedia.list_image_urls() == [image_url]
    end

    test "get_image_url!/1 returns the image_url with given id" do
      image_url = image_url_fixture()
      assert Multimedia.get_image_url!(image_url.id) == image_url
    end

    test "create_image_url/1 with valid data creates a image_url" do
      assert {:ok, %ImageUrl{} = image_url} = Multimedia.create_image_url(@valid_attrs)
      assert image_url.url == "some url"
    end

    test "create_image_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_image_url(@invalid_attrs)
    end

    test "update_image_url/2 with valid data updates the image_url" do
      image_url = image_url_fixture()
      assert {:ok, %ImageUrl{} = image_url} = Multimedia.update_image_url(image_url, @update_attrs)
      assert image_url.url == "some updated url"
    end

    test "update_image_url/2 with invalid data returns error changeset" do
      image_url = image_url_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_image_url(image_url, @invalid_attrs)
      assert image_url == Multimedia.get_image_url!(image_url.id)
    end

    test "delete_image_url/1 deletes the image_url" do
      image_url = image_url_fixture()
      assert {:ok, %ImageUrl{}} = Multimedia.delete_image_url(image_url)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_image_url!(image_url.id) end
    end

    test "change_image_url/1 returns a image_url changeset" do
      image_url = image_url_fixture()
      assert %Ecto.Changeset{} = Multimedia.change_image_url(image_url)
    end
  end

  describe "internet_images" do
    alias Trivium.Multimedia.InternetImage

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def internet_image_fixture(attrs \\ %{}) do
      {:ok, internet_image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Multimedia.create_internet_image()

      internet_image
    end

    test "list_internet_images/0 returns all internet_images" do
      internet_image = internet_image_fixture()
      assert Multimedia.list_internet_images() == [internet_image]
    end

    test "get_internet_image!/1 returns the internet_image with given id" do
      internet_image = internet_image_fixture()
      assert Multimedia.get_internet_image!(internet_image.id) == internet_image
    end

    test "create_internet_image/1 with valid data creates a internet_image" do
      assert {:ok, %InternetImage{} = internet_image} = Multimedia.create_internet_image(@valid_attrs)
      assert internet_image.url == "some url"
    end

    test "create_internet_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_internet_image(@invalid_attrs)
    end

    test "update_internet_image/2 with valid data updates the internet_image" do
      internet_image = internet_image_fixture()
      assert {:ok, %InternetImage{} = internet_image} = Multimedia.update_internet_image(internet_image, @update_attrs)
      assert internet_image.url == "some updated url"
    end

    test "update_internet_image/2 with invalid data returns error changeset" do
      internet_image = internet_image_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_internet_image(internet_image, @invalid_attrs)
      assert internet_image == Multimedia.get_internet_image!(internet_image.id)
    end

    test "delete_internet_image/1 deletes the internet_image" do
      internet_image = internet_image_fixture()
      assert {:ok, %InternetImage{}} = Multimedia.delete_internet_image(internet_image)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_internet_image!(internet_image.id) end
    end

    test "change_internet_image/1 returns a internet_image changeset" do
      internet_image = internet_image_fixture()
      assert %Ecto.Changeset{} = Multimedia.change_internet_image(internet_image)
    end
  end
end
